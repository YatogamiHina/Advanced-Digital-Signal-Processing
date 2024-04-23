clc; clear; close all;

%% Parameter
filter_length = 21;
sampling_frequency = 8000;
pass_band_frequency = [1800 4000];
transition_band_frequency = [1600 2000];
weighting = [0.8 1];
delta = 0.0001;
interval = 0.0001;

%% Mini-max Highpass FIR Filter
tic;
[iteration, E_iteration, s, h] = mini_max_highpass(filter_length, sampling_frequency, pass_band_frequency, transition_band_frequency, weighting, delta, interval);
toc;
