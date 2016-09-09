% combine multiple csv to worksheets in one xls
yourfolder='H:/Dropbox/Research/energyStudy/wind/station/test'
% get csv file information 
d=dir([yourfolder '\*.csv']);
files={d.name};
for k=1:numel(files)
   old_name=files{k}; 
   % get the data from csv one by one
   [~,~,b] = xlsread(old_name) ;
   % get the file name as work sheet name
   new_name=strrep(old_name,'_weather_data1.csv','');
   %xlswrite(new_name,b);
   % data is too large, xls not working, so xlsx
   filename = 'windSpeedInt.xls';
   xlRange = 'A1:K8785';
   xlswrite(filename,b,new_name,xlRange);
end