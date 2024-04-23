clc; clear all; close all; warning('off');

%% Parameter

k = 4; % set any integer
H_range = [-0.5 0.5];
H = j * 2 * pi; % H(F) = j2πF
transition_band = [0.5 0.5];
interval = 0.001;

% FSM(k, H_range, H, interval); % without transition band
FSM(k, H_range, H, interval, transition_band);