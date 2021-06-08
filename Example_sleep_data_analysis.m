% Computational Approaches to Signal Processing for Sleep
% An Introduction to Network Analysis & EEG Interpretation
%
% Mark Kramer, Jun 2021.

clear; clc                          % Clear the workspace.
close all                           % Close all figures
addpath('helper')                   % Add a folder with helpful functions.

%% Step 1a. Data collection ------------------------------------------------
%
load('Example_sleep_data.mat')   	% Load the data
                                   	%    d = the data [ time, electrodes ]
                                  	%    t = the time axis, in units of seconds.
                                    %    detections = spindle detections [time, electrodes]
figure(); eeg_plot(t,d,'')          % It's always a good idea to look at the raw data.
title('EEG data'); xlabel('Time [s]')

%% Step 1b. Spectrogram ----------------------------------------------------
%
simple_spectrogram(d(:,1),t);       % Make spectrogram for 1st electrode.

%% Step 2. Re-referencing --------------------------------------------------
% 
% N/A

%% Step 3. Filtering -------------------------------------------------------
%
% N/A

%% Step 4. Network inference -----------------------------------------------
%
%                                   % Infer the functional connectivity,
[C] = infer_network_coherence(t,d,detections);
figure(); pcolor(C); caxis([0,1]); colorbar 	% ... and visualize it.
xlabel('Node number'); ylabel('Node number'); title('Coherence (9-16 Hz)')

%% TRY AGAIN ... %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Step 3. Filter & visualize spindle detections ---------------------------
%
%
Wn = [2,50];                        % Choose filter range from [2,50] Hz,
d_filtered = simple_filter(t,d,Wn); % ... apply the filter.
figure(); eeg_plot(t,d_filtered,''); hold on; eeg_plot(t,0.5*detections,'k'); hold off
title('EEG data'); xlabel('Time [s]')

%% Step 4. Network inference -----------------------------------------------
%
%                                   % Infer the functional connectivity,
[C] = infer_network_coincidence(t,d,detections);
figure(); pcolor(C); colorbar;      % ... and visualize it.
xlabel('Node number'); ylabel('Node number'); title('Coincidence')

%% TRY AGAIN ... %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Step 4. Network inference ----------------------------------------------
%
%                                   % Infer the functional connectivity,
[C] = infer_network_coincidence_scaled(t,d,detections);
figure(); pcolor(C); colorbar;      % ... and visualize it.
xlabel('Node number'); ylabel('Node number'); title('Coincidence scaled')
