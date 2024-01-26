%%=====  Import_HDF.m ========================================%
%Date: November 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will import the original raw data of specified Inertial Motion
%Units (IMUs) and save the data to a pre-determined filepath. In subsequent
%steps, the data will be processed first and lastly, upsampled towards the 
%same EEG sampling frequency.
%===================================================================

close all

IMU_data                             = struct;
[h5_file,filepath]                   = uigetfile('*.h5');                                         % Open file window and extract the desired h5. file
IMU_data.filename                    = strrep(h5_file,'.h5','');                                  % Creates the filename by cutting off the suffix (.h5)
cd(filepath)  

IMU_data.info                        = h5info(h5_file);
IMU_data.file                        = h5_file; 

IMU_data.measurement{1,1}            = ['Accelerometers']; 
IMU_data.measurement{2,1}            = ['Gyroscopes'];
IMU_data.measurement{3,1}            = ['Magnetometers'];

IMU_data.location{1,1}               = IMU_data.info.Attributes(1).Value(1);                              % ['Right Foot'];             % IMU 1683
IMU_data.location{2,1}               = IMU_data.info.Attributes(1).Value(2);                              % ['Left Foot'];              % IMU 1710
IMU_data.location{3,1}               = IMU_data.info.Attributes(1).Value(3);                              % ['Lumbar'];                 % IMU 1726
IMU_data.fs                          = double(IMU_data.info.Groups(1).Attributes(2).Value);               % Extract IMU sampling frequency


%Now extracting the IMU information
for m = 1:length(IMU_data.measurement);
   %Saving Accelerometer Data
   IMU_data.name{m,1}               = IMU_data.info.Groups(m).Name;
   grp                              = IMU_data.measurement{1,1};
   path                             = [IMU_data.name{m,1} '/Calibrated/' grp];
   IMU_data.Accelerometer(m).Sensor = h5read(IMU_data.file,path)';

   %Saving Gyroscope Data:
   IMU_data.name{m,1}              = IMU_data.info.Groups(m).Name;
   grp                             = IMU_data.measurement{2,1};
   path                            = [IMU_data.name{m,1} '/Calibrated/' grp];
   IMU_data.Gyroscope(m).Sensor    = h5read(IMU_data.file,path)';

   %Saving Magnetometer Data:
   grp                             = IMU_data.measurement{3,1};
   IMU_data.name{m,1}              = IMU_data.info.Groups(m).Name;
   path                            = [IMU_data.name{m,1} '/Calibrated/' grp];
   IMU_data.Magnetometer(m).Sensor = h5read(IMU_data.file,path)';
end
    
%Resample IMU data up to EEG sampling rate
for i = 1:length(IMU_data.measurement)
    IMU_data.interp_gyroscope(i).Sensor      = resample(IMU_data.Gyroscope(i).Sensor, 1000, IMU_data.fs);
    IMU_data.interp_accelerometer(i).Sensor  = resample(IMU_data.Accelerometer(i).Sensor, 1000, IMU_data.fs);
    IMU_data.interp_magnetometer(i).Sensor   = resample(IMU_data.Magnetometer(i).Sensor, 1000, IMU_data.fs);
end

%Creating an EEG Timevector:
IMU_data.imutime = (1/1000):(1/1000):(length(IMU_data.interp_accelerometer(1).Sensor)/1000);
IMU_data.eegtime = (1/1000):(1/1000):(length(IMU_data.interp_accelerometer(1).Sensor)/1000);

%Deleting unneccessary data
IMU_data = rmfield(IMU_data,{'fs';'Accelerometer'; 'Gyroscope'; 'Magnetometer'});

%Save DATA
save([filepath IMU_data.filename '_raw.mat'], 'IMU_data', '-mat')       

%Clean-UP
clear i m h5_file grp path

% *********************** END OF SCRIPT ************************************************************************************************************************
