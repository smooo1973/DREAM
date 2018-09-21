function [freqbands,output_mtx] = AFD_FreqCalc_IMG(TR,filepath,sub_list,func,filename)
sublist_all = importdata(sub_list)
files = cellstr(filename)
%flag = 0;
for tem = 1:length(sublist_all)
    cd (filepath)
    subj = char(sublist_all(tem,1));
 %   if (flag == 0)
        savepath = [filepath,'/', subj,'/',func]
        savep = [savepath,'/DREAM.mat']
        save(savep)
  %      flag = 1
   % end
    afdpath = [filepath '/' subj '/' func]
    %%ccs_core_lfofreqbands2
    for ii = 1:length(files)
        file = files{ii,1}
        
        subj_v=load_nifti([afdpath '/' file])

        num_samples = size(subj_v.vol,4);
                
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
        
        cd (afdpath)
        savefile = strrep(file,'.nii.gz','FBs')
        mkdir(savefile)
        dir_path = [afdpath '/' savefile]
        csvwrite([dir_path '/freqbands.csv'],freqbands)
    end
end
end