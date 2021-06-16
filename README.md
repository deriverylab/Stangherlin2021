# Stangherlin2021
Codes for detection, tracking and analysis of quantum dots in cells. From Stangherlin et al., Nature Communications, 2021.

This document describes the installation and usage of codes for the tracking of quantum dots (QDs) diffusing in the cytosol of cells.
Emmanuel Derivery and Joseph Watson


This folder contains one cropped movie per time point (24h, 36h, 48h, 60h), upon which to test the codes.
-------------------------------------------------------------------------------------------------------------------------------------


System Requirements:

Software:
Fiji (with ImageJ 1.52t and Thunderstorm plugin)
MATLAB R2020a (with msdanalyzer library)

Codes (attached in this folder):
batch_thunderstorm.ijm
tracking_MSD_batch_dataset.m
FOV_medianMSD_batch.m
track2.m


Software used in this study:
Fiji (with ImageJ 1.52t and Thunderstorm plugin)
MATLAB R2020a (with msdanalyzer library)

Expected install time < 1 hour on 'normal' computer
-------------------------------------------------------------------------------------------------------------------------------------

Demo:

-------------------------------------------------------------------------------------------------------------------------------------

Directory Structure:

Files are stored and analysed in the following directory structure:

main/raw/conditions/images

where the 'conditions' directories represent the experimental conditions of the images held within.


-------------------------------------------------------------------------------------------------------------------------------------


Step 1: Detection of QDs

Quantum dots are detected by Gaussian fitting using the Thunderstorm plugin for imageJ/Fiji (https://zitmen.github.io/thunderstorm/)

>>> In Fiji, run 'batch_thunderstorm.ijm' in the 'raw' directory.

NB, the batch_thunderstorm macro contains camera parameters specific to the microscope on which the data were generated


-------------------------------------------------------------------------------------------------------------------------------------


Step 2: Tracking the QDs and estimating their mean square displacement (MSD) coefficient

>>> Execute tracking_MSD_batch_dataset.m in MATLAB, in the 'main' directory

Briefly, this code tracks the detected QDs, allowing for a gap of up to 5 'missing' frames, and taking tracks only if they exceed 15 time points in length.
The MSD of these tracks is then computed, fitted to a confined model of diffusion (MSD(t) = 4Dt^alpha), where alpha represents a confinement parameter. 
The code takes a timing file to estimate diffusion speeds.


-------------------------------------------------------------------------------------------------------------------------------------


Step 3: Extracting average MSD coefficients for diffusive tracks

>>> Execute FOV_medianMSD_batch.m in 'main' directory

Briefly, this code takes only tracks with a good fit to a confined diffusion model (r > 0.9), and filters out immobile QDs (alpha < 0.45). These filtered tracks
represent diffusive QDs. The first 50 time points of these track (where the relationship between MSD and time evolves approximately linearly) are then fit 
to an unconstrained diffusion model (MSD(t) = 4Dt). The median diffusion coefficient for each field of view is then calculated and saved in the file 
'medianMSDperFOV' in the main directory. It is these values upon which the statistics for each condition are subsequently generated.


-------------------------------------------------------------------------------------------------------------------------------------

Expected output is in 'ExpectedOutput.xlsx'
Expected run time is < 30 minutes on a 'normal' computer


