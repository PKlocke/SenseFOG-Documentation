# SenseFOG README

This GitHub File (titled "SenseFOG-Documentation") contains the source code to access and process data deposited on a Mendeley Data Repository (see below) for the manuscript titled "Supraspinal circuits contribute to the failure of antagonistic inhibition and freezing of gait in Parkinson’s disease” (DOI: 10.17632/c9ckcvjxc7.1).


## Contact Person: 
For additional queries, contact: 
- [ ] Philipp Klocke;  philipp.klocke@uni-tuebingen.de
- [ ] Moritz Loeffler; moritz.loeffler@uni-tuebingen.de

## Overview

- [ ] Project name: SenseFOG
- [ ] Years of subject and data recruitment: 2020-2023
- [ ] Overall study goal:
      We set out to study the neuronal and neuromuscular basis of freezing of gait (FoG) events in Parkinson's disease (PD) patients while walking by taking advantage
      of subthalamic sensing technology and ambulatory EMG recordings. To differentiate these from events of voluntary stopping, we also recorded stopping events in PD patients.  


## Data Repository

### Where to access the raw data
To access, download and analyze data, please visit the public data repository on Mendeley Data where the data has been stored:
“Supraspinal circuits contribute to the failure of antagonistic inhibition and freezing of gait in Parkinson’s disease”, Mendeley Data, V1, doi: 10.17632/c9ckcvjxc7.1

- [ ] https://data.mendeley.com/datasets/c9ckcvjxc7/1
             

## System Requirements
### Hardware Requirements
The SenseFOG-Documentation alongside the provided data requires a standard-computer with enough RAM to support the operations. 

### Software Requirements
Computer code and running the analysis pipeline has been written and tested using MacOS Monterey but is also compatible with Microsoft Windows. For analysis, MatLab version 2022a was used (MathWorks, Nattick, MA, USA, https://de.mathworks.com/products/matlab.html). 


## Installation Guide

### MatLab Package Dependencies
Before running the analyses scripts, users should make sure to install the following MatLab toolboxes:

- [ ] Fieldtrip (version 1.0.1.0)
- [ ] MatLab Wavelet Toolbox (version 6.1)
- [ ] MatLab Signal Processing Toolbox (version 9.0)

Installtime of MatLab as well as specified toolboxes should only take a few minutes.
Running the entire analysis pipeline will consume up to 20 GB of storage data, provided that all steps of data preprocessing and anaylsis are retained on the storing device.


## Demo
### Instructions to run on data
A demo for the first 60 seconds of regular walking in subject 10 has been created. The Matlab script is stored under the subfolder "Demo" and uses pre-specified time points of heel strike events in subject 10.
Specify the pathway to load the data stored under SenseFOG-Documentation/Demo/sub-10-dataevents.mat.
Make sure that pre-specified toolboxes in MatLab have been installed before running the script. 

### Expected output
Based on the time points for heel strikes of the left leg, the script will first produce a continous wavelet transform time-frequency matrix and segment the matrix according to the heelstrikes (Gait Cycles). Individual gait cycles will then be resampled to bring epochs up to the same length (1000 samples). TF-epochs for left and right STN will be averaged and plotted together with the corresponding IMU data. The generated output represents time-frequency information (2-100 Hz) for gait cycles of the left leg.

### Expected run time for demo 
Run time after loading in the data should not exeed 60 seconds. 

## Instructions for use
### How to run the software on your data and reproduction instructions
For detailed instructions on how to proceed with preprocessing of the raw data and analysing the preprocessed data, please see the "Instructions.md" page listed in SenseFOG-Documentation/Instructions.md. 


## Additional information on study subjects and data aquisition
### Subjects
12 patients with idiopathic Parkinson's disease who had previously undergone bilateral STN-DBS surgery and were implanted with the Medtronic Percept impulse generator were studied.
Please find detailed information on included subjects by searching for the published manuscript on PubMed or contact the authors.

Inclusion Criteria:
- [ ] Patients aged 18-85 years
- [ ]	Patients diagnosed with idiopathic PD according to the UK Parkinson Disease Brain Bank criteria
- [ ] Patients must be implanted with bilateral DBS whose DBS-electrodes conform to Medtronic lead models 3389, 3387 or Sensight™ and who currently are implanted with the Percept™ impulse generator
- [ ] Electrode contacts reside within the STN
- [ ] Implantation of DBS electrodes occurred no prior than 6 months before enrolment

Exclusion Criteria:
- [ ]	Competing orthopaedic or neurological conditions rendering patients unable to walk unaided
- [ ]	Marked cognitive impairment (Montreal Cognitive assessment [MoCA]) < 17 points
- [ ]	Patients with current moderate to severe depression (Beck Depression Inventory [BDI]) ≥ 24 points
- [ ] Patients with current psychotic symptoms and/or suicidality

### Apparatus
To record local field potentials (LFP), sensing abilities of the Medtronic Percept were used. Data were recorded and saved in a .json file. Additionally, we recorded EEG/EMG data (Brain products, MES Electronics, Gilching, Germany), data being saved in a .bva file. 
Lastly, gait kinematics were recorded using three lightweight inertial kinematic sensors (Opal, APDM Inc., Portland, OR USA) attached to both left and right ankles and lumbar spine (L5). All kinematic data were exported in hierarchical data format (HDF) and saved in a .h5 file. All experimental sessions were videotaped for later offline-analysis. 

### Task organization
Patient first underwent baseline clinical assessment after overnight withdrawal of all dopaminergic medication (>12 hours). 
Recording sessions were the following: 
- [ ] Sitting (eyes open): 120 seconds (ses-sitting)
- [ ] Standing (eyes open): 120 seconds (ses-standing)
- [ ] Walking through a naroow corridor as mono task (approx. 240 seconds duration) (ses-walk)
- [ ] Walking being unterrupted by internally generated voluntary stops (approx. 240 seconds duration) (ses-walkws)
- [ ] Walking under dual task conditions (serial subtraction task) (approx. 240 seconds duration) (ses-walkint)
All recordings took place in Med OFF and Stim OFF. 


### Task details
Based on the provided videofiles and kinematic data, we have created start and end time points for the following events:
- [ ] Walking (straight walking, no freezing of gait detected)
- [ ] Turning (start and and end time points)
- [ ] Self-Selected Stops
- [ ] Freezing of Gait [Walking]


For walking, we included time series both while walking straight ahead as mono task and walking with interference (dual-task).
We rejected all time segments including turning, FoG, or stops. Further, we excluded a three-second time segment from the transition periods (Pre-FoG or Pre-Stop) and the first step before and after a turn to exclude acceleration and deceleration of walking. 

In the current work, we restricted analyes to FoG occuring during walking, thereby excluding FoG during turning or at gait initiation. 
We segmented FoG-events beginning with the last regular heelstrike contralateral to the leg displaying freezing and ending with the first heel strike after a FoG-event when regular walking was resumed. Only FoG episodes lasting ≥1000 ms were selected.

Self-Selected Stops were identified in the video recordings and segmented based on the kinematic time series. 
Their start was defined as the time point of the heel strike of the leg initiating stance phase before full termination of walking activity. Toe-off of the leg resuming walking-activity was used to define the offset of a voluntary stop. Only stops lasting ≥1000 ms were included. 

To study the transition phases from walking to FoG (termed Pre-FoG) or voluntary stops (termed Pre-Stop), we chose the last three gait cycles before each event. In case of slow walking, gait cycles occurring more than 3000 ms before FoG/Stop onset were excluded. 

### Computation of Gait Cycle
During offline analysis, gait cycles were identified using the accelerometer signal in the anterior-posterior plane (x-axis) and the gyroscope signal in the medial-lateral direction (y-axis) with angular velocity expressed in the sagittal plane. We characterized each gait cycle by identifying the midswing, defined by the gyroscope’s peak-angular velocity exceeding a threshold of 50°/s. Using a time window of 500 ms before and after each midswing, the preceding toe-offs and the succeeding heel strikes were identified. Toe off was marked as the minimum acceleration in the anterior-posterior plane and heel strike as the minimum angular velocity in the sagittal plane before maximum anterior-posterior acceleration, respectively. A 100% full stride encompassed the timespan between two consecutive heel strikes of the same leg. Gait cycles exceeding a duration of > 2.5 s were discarded. Temporal and spatial gait parameters from these regular gait cycles (referred to as “walking” in the following”) were computed for each subject and gait condition.

### Assessment of disease laterality
We obtained further clinical characteristics by recording motor symptoms (MDS-UPDRS part III in medication off / stimulation off and medication on / stimulation on) including evaluation of the MDS-UPDRS III hemibody scores to determine disease-lateralization (calculated as sum of the rigidity (item 3.3), akinesia (items 3.4-3.8), and tremor (items 3.15-3.17) scores for one side, ranging from 0 to 44). The hemibody ranking highest on the MDS-UPDRS sum score was chosen as disease dominant side and the contralateral STN chosen as disease dominant STN.

### Experimental location
Recordings took place on the premises of the University Hospital Medical Center Tübingen, Department of Neurology.
Gait tasks took place in a 15 x 2.5 m hallway. Two chairs narrowing the corridor were positioned (1 m width) to help provoke FoG events under laboratory conditions.

### Ethics
The study was approved by the Ethics Committee of Tübingen University (166/2020BO1), and all patients provided written informed consent.
