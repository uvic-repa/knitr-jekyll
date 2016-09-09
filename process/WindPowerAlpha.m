%---------DERIVING WIND POWER DATA---------------------------------------
Alpha = 0.22; %Determined from knowledge of wind speeds at 10 & 45 m
Hhub = 74; % Hub height=99m according to E-33 brochure
Hdata = 10; %Average wind speed at 10 m (45m) is 6.71 m/s (8.32m/s)
meanwind=6.71;
rho_sealevel = 1.225; %Air density at sea level
rho_makelle = 0.94; %Air density Mekelle (inferred from InWEnt report)
% Call 'randraw.m' to obtain Weibull distribution of wind speed
% Need shape, scale and location parameters; the latter is zero
shape=2.06;
scale=9.38;
location=0;

% To calculate wind power output for the Enercon E-101 turbine (3.5 mW)
% Cut-in wind speed is 2 m/s
cutin=2;
%Cut-out wind speed is 28-34 m/s
cutoff=30.0;
% Wind-to-power conversion table for wind turbine
A = xlsread ('WindPowerTurbines.xls', 'Turbine', 'B140:C164');
E101NameplateCap=xlsread('WindPowerTurbines.xls', 'Turbine', 'H168');

%--------------------SIMULATION LOOP-------------------------------------
%for n=1:simulations

%Vdata = WindMeanRevert(location, shape, scale, meanwind, number+10);

%s = 'B':'K'
%new windSpeedInt has change the position
s= 'D':'O';
  
for ns=1:length(s)
		% new windSpeedInt has 8761 rows
        xlRange = strcat(s(ns),'2:',s(ns),'8761');
        Vdata = xlsread('windSpeedInt.xls', 'WHITECOURT', xlRange);

        % The new wind velocity at the turbine hub height [m/s]
        Vhub = ((Hhub/Hdata)^Alpha).*Vdata;
        %Vhub = Vdata.*(log(Hhub/0.02)/log(Hdata/0.02));

        % Call function to WindPower() to calculate the wind power output
        [wp]=WindPower(Vhub, A, cutin, cutoff);
        [wp]= transpose(wp/1000)
        %for i=1:turbines
        %    windpower(i,:)=wp(1:number)*i*rho_makelle/rho_sealevel;
        %end;


        %--------------------WRITE RESULT TO FILE-------------------------------------
        %for n=1:simulations

        filename = 'PowerOutputMW';
        sheet = 1;
        xlswrite(filename,wp,sheet, s(ns));
    
end 
   
