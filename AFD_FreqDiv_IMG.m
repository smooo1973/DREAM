function [freqbands,output_mtx] = AFD_FreqDiv_IMG(filepath,freqn)
cd (filepath)
cd ..
load('DREAM.mat')
sublist_all = importdata(sub_list)
files = cellstr(filename)
for tem = 1:length(sublist_all)
    cd (filepath)
    subj = char(sublist_all(tem,1));
    afdpath = [filepath '/' subj '/' func]
    %%ccs_core_lfofreqbands2
    for ii = 1:length(files)
        file = files{ii,1}
        
        subj_v=load_nifti([afdpath '/' file])
        X= size(subj_v.vol,1)
        Y= size(subj_v.vol,2)
        Z = size(subj_v.vol,3)
        num_samples = size(subj_v.vol,4);
        
        subj_vol= reshape(subj_v.vol,X*Y*Z,num_samples);

        % Set up variables
        N = num_samples;
        fmax = 1/(2*TR); fmin = 1/(N*TR/2);
        if rem(N,2)==0
            fnum = N/2;
        else
            fnum = (N+1)/2;
        end
        freq = linspace(0,fmax,fnum+1);
        tmpidx = find(freq<=fmin);
        frmin = freq(tmpidx(end)+4); % minimal reliable frequency
        
        %% Determine the range of frequencies in natural log space
        
        nlcfmin = fix(log(frmin));
        nlcfmax = fix(log(fmax));
        nlcf = nlcfmin:nlcfmax;
        numbands = numel(nlcf);
        freqbands = cell(numbands,1);
        for nlcfID=1:numbands
            [~,idxfmin] = min(abs(freq-exp(nlcf(nlcfID)-0.5)));
            [~,idxfmax] = min(abs(freq-exp(nlcf(nlcfID)+0.5)));
            freqbands{nlcfID} = [freq(idxfmin) freq(idxfmax)];
        end
        %modify the min band and max band
        tmpf = freqbands{1};
        if tmpf(1)<frmin
            tmpf(1) = frmin;
            freqbands{1} = tmpf;
        end
        tmpf = freqbands{end};
        if tmpf(2)>fmax
            tmpf(2) = fmax;
            freqbands{end} = tmpf;
        end
        
        
        %%��������
        input_mtx= subj_vol'
        
        
        if (freqn==0)
            for i =1:length(freqbands)
                low_f = min(freqbands{i,1})
                high_f = max(freqbands{i,1})
                if (low_f >= high_f)
                    error('ERROR: Bandstop is not allowed.')
                end
                
                % sample frequency
                Fs = 1/TR;
                
                % sample points
                L = size(input_mtx, 1);
                
                if (mod(L, 2) == 0)
                    % If L is even
                    f = [0:(L/2-1) L/2:-1:1]*Fs/L;  %frequency vector
                elseif (mod(L, 2) == 1)
                    % If L is odd
                    f = [0:(L-1)/2 (L-1)/2:-1:1]*Fs/L;
                end
                
                % index of frequency that you want to keep
                ind = ((low_f <= f) & (f <= high_f));
                
                % create a rectangle window according to the cutoff frequency
                rectangle = zeros(L, 1);
                rectangle(ind) = 1;
                
                % use fft to transform the time course into frequency domain
                fprintf('FFT each time course.\n')
                input_mtx_fft = fft(input_mtx);
                
                % apply the rectangle window and ifft the signal from frequency domain to time domain
                fprintf('Apply rectangle window and IFFT.\n')
                output_mtx{i,1} = ifft(bsxfun(@times, input_mtx_fft, rectangle));
                
                %p = ['figure(',num2str(i),')']
                %eval(p)
                %temp_mtx = output_mtx{i,1}'
                %temp_mtx(all(temp_mtx== 0, 2),:) = [];
                %temp_mtx = mean(temp_mtx);
                %plot(temp_mtx(1,:))
                
                subj_v_vol = output_mtx{i,1}
                subj_v_vol = subj_v_vol'
                subj_v.vol= reshape(subj_v_vol,X,Y,Z,N);
                
                cd (afdpath)
                savefile = strrep(file,'.nii.gz','FBs')
                mkdir(savefile)
                dir_path = [afdpath '/' savefile]
                p = ['save_nifti(subj_v ,''', dir_path ,'/',savefile , num2str(i), '.nii.gz', ''')']
                eval(p)
                
            end
        else
            i = freqn
            low_f = min(freqbands{i,1})
            high_f = max(freqbands{i,1})
            if (low_f >= high_f)
                error('ERROR: Bandstop is not allowed.')
            end
            
            % sample frequency
            Fs = 1/TR;
            
            % sample points
            L = size(input_mtx, 1);
            
            if (mod(L, 2) == 0)
                % If L is even
                f = [0:(L/2-1) L/2:-1:1]*Fs/L;  %frequency vector
            elseif (mod(L, 2) == 1)
                % If L is odd
                f = [0:(L-1)/2 (L-1)/2:-1:1]*Fs/L;
            end
            
            % index of frequency that you want to keep
            ind = ((low_f <= f) & (f <= high_f));
            
            % create a rectangle window according to the cutoff frequency
            rectangle = zeros(L, 1);
            rectangle(ind) = 1;
            
            % use fft to transform the time course into frequency domain
            fprintf('FFT each time course.\n')
            input_mtx_fft = fft(input_mtx);
            
            % apply the rectangle window and ifft the signal from frequency domain to time domain
            fprintf('Apply rectangle window and IFFT.\n')
            output_mtx{i,1} = ifft(bsxfun(@times, input_mtx_fft, rectangle));
            
            %p = ['figure(',num2str(i),')']
            %eval(p)
            %temp_mtx = output_mtx{i,1}'
            %temp_mtx(all(temp_mtx== 0, 2),:) = [];
            %temp_mtx = mean(temp_mtx);
            %plot(temp_mtx(1,:))
            
            subj_v_vol = output_mtx{i,1}
            subj_v_vol = subj_v_vol'
            subj_v.vol= reshape(subj_v_vol,X,Y,Z,N);
            
            cd (afdpath)
            savefile = strrep(file,'.nii.gz','FBs')
            mkdir(savefile)
            dir_path = [afdpath '/' savefile]
            p = ['save_nifti(subj_v ,''', dir_path ,'/',savefile , num2str(i), '.nii.gz', ''')']
            
            eval(p)
            
        end
    end
end
end