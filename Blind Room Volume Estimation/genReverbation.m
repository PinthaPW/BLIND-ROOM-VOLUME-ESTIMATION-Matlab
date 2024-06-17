clear all;

% ===== Please select clean speech audio file =========
[SPfilenames, SPpathname, filterindex] = uigetfile('*.flac', 'WAV-files (*.wav)', 'Select speech', 'MultiSelect', 'on');
% ===== Please select RIRs .mat file ==================
[hfilenames, hpathname, ~] = uigetfile('*.wav', 'WAV-files (*.wav)', 'Select RIRs', 'MultiSelect', 'on');


count = 0;
path = '/Users/nutchanonsiripool/Documents/MATLAB/Sound Data/genReverbation speech/'; 

for i = 1:length(SPfilenames)
    fileSP = fullfile(SPpathname,SPfilenames(i));
    [SP,fs1] = audioread(string(fileSP));  
     ind = find(SP>0.2,1,'first');
     sp = SP(ind:end);
          
    for k =1:1%length(hfilenames)
        fileh = fullfile(hpathname,hfilenames(k,:)); 
        [h, fs2] = audioread(string(fileh(k,:))); 

        L = size(h,1);
        t = linspace(0, L-1, L)/fs2;                            % Time Vector
        fs_new = fs1;
        [yr,tr] = resample(h, t(:), fs_new);                   % Resample To New Sampling Frequency


        revSP = conv(sp,h);
        out = revSP./max(revSP);

        filename = strcat(hfilenames(k,1:end-4),'_',SPfilenames{i}(1:end-4),'.wav');
        here = strcat(path,filename);       
        audiowrite(here,out,fs_new,'BitsPerSample',32);
        count = count +1;
        disp(count);
    end
end  