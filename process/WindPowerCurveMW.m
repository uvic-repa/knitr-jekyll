%---------DERIVING WIND POWER DATA---------------------------------------



% we might use those parameters in simulation. 
%but when calculating power curve, we have not use them yet. ??? 

Alpha = 0.143; %Determined from knowledge of wind speeds at 10 & 45 m
Hhub = 74; % Hub height=99m according to E-101 brochure
Hdata = 10; %Average wind speed at 10 m (45m) is 6.71 m/s (8.32m/s)
meanwind=6.71; % Wind data from stats CA is record at 10m

% How do we use these parameters???
rho_sealevel = 1.225; %Air density at sea level
rho_makelle = 0.94; %Air density Mekelle (inferred from InWEnt report)


% Call 'randraw.m' to obtain Weibull distribution of wind speed
% Need shape, scale and location parameters; the latter is zero
shape=2.06;
scale=9.38;
location=0;

% To calculate wind power output for the Enercon E-101 turbine (3.5 MW), ENERCON 2016
% Cut-in wind speed is 2 m/s
cutin=2;
%Cut-out wind speed is 28-34 m/s
cutoff=30.0;



% Wind-to-power conversion table for wind turbine
% converttable is calculated by what formula??
ConvertTable = xlsread('WindPowerTurbines.xls', 'Turbine', 'B140:C164');

% why we do not use this parameters
E101NameplateCap= xlsread('WindPowerTurbines.xls', 'Turbine', 'H168');

%--------------------CALCULATION LOOP-------------------------------------
%for n=1:simulations

%Vdata = WindMeanRevert(location, shape, scale, meanwind, number+10);

%sitename =xlsread('newID02.xls','newID02','B2:B18');
[~,~,site_n] = xlsread('newID02.csv') ;
%http://www.mathworks.com/help/matlab/matlab_prog/cell-arrays-of-strings.html
% cell to char vector 

for i=1:length(site_n)-1;
    % sheet name is upper
    %upper(site_n{i+1,2})
    sheet = char(upper(site_n(i+1,2)));
    Alpha =site_n{i+1,11};
    s= 'D':'O';
    for ns=1:length(s)
        xlRange = strcat(s(ns),'2:',s(ns),'8761');
                      
        Vdata = xlsread('windSpeedInt.xls',sheet, xlRange);

        % The new wind velocity at the turbine hub height [m/s]

        Vhub = ((Hhub/Hdata)^Alpha).*Vdata;
        %Vhub = Vdata.*(log(Hhub/0.02)/log(Hdata/0.02));

        % Call function to WindPower() to calculate the wind power output and
        % convert from kw to mw
        [wp]=WindPower(Vhub, ConvertTable, cutin, cutoff);
        [wp]= transpose(wp/1000);

        % ? why we need to multiple by i and rho_makelle/rho_sealevel
        % what is 'turbines' here? represent ???? and what is 'number'?
        %for i=1:turbines
        %    windpower(i,:)=wp(1:number)*i*rho_makelle/rho_sealevel;
        %end;
        %--------------------WRITE RESULT TO FILE-------------------------------------
        %for n=1:simulations
        filename = 'WindPowerMw01.xlsx';
        xlswrite(filename,wp,sheet,xlRange);
    end
end    



   sheet = char(upper(site_n(12,2)));
    Alpha =site_n{12,11};
    s= 'D':'O';
    for ns=1:length(s)
        xlRange = strcat(s(ns),'2:',s(ns),'8761');
                      
        Vdata = xlsread('windSpeedInt.xls',sheet, xlRange);

        % The new wind velocity at the turbine hub height [m/s]

        Vhub = ((Hhub/Hdata)^Alpha).*Vdata;
        %Vhub = Vdata.*(log(Hhub/0.02)/log(Hdata/0.02));

        % Call function to WindPower() to calculate the wind power output and
        % convert from kw to mw
        [wp]=WindPower(Vhub, ConvertTable, cutin, cutoff);
        [wp]= transpose(wp/1000);

        % ? why we need to multiple by i and rho_makelle/rho_sealevel
        % what is 'turbines' here? represent ???? and what is 'number'?
        %for i=1:turbines
        %    windpower(i,:)=wp(1:number)*i*rho_makelle/rho_sealevel;
        %end;
        %--------------------WRITE RESULT TO FILE-------------------------------------
        %for n=1:simulations
        filename = 'WindPowerMw03.xlsx';
        xlswrite(filename,wp,sheet,xlRange);
    end



[N,edges] = histcounts(wp) 

[N,edges] = histcounts(X,k)

histogram(wp)

%Assuming a package is available in the file image-1.0.0.tar.gz it can be installed from the Octave prompt with the command

%pkg install image-1.0.0.tar.gz

%If the package is installed successfully nothing will be printed on the prompt, 
%but if an error occurred during installation it will be reported. 
%It is possible to install several packages at once by writing several package files after the pkg install command. 
%If a different version of the package is already installed it will be removed prior to installing the new package. 
%This makes it easy to upgrade and downgrade the version of a package, 
%but makes it impossible to have several versions of the same package installed at once. 
