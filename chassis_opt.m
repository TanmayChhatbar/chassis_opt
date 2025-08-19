clear
clc
addpath('fcn');

%% define frame
frame.vertices = [   0,   0,   0; % front frame
                     0,   0.2, 0;
                     0,   0.2, 0.2;
                     0,   0,   0.2;
                    -0.4, 0,   0;
                    -0.4, 0.2, 0;
                    -0.4, 0.2, 0.2;
                    -0.4, 0,   0.25;
                    -0.7, 0.2, 0.25;
                ];
frame.edges = [ 1, 2; % lower front lateral
                2, 3; % left front vertical
                3, 4; % upper front lateral
                4, 1; % right front vertical
                1, 3; % diagonal front
                1, 5; % right lower longitudinal
                2, 6; % left lower longitudinal
                3, 7; % left upper longitudinal
                4, 8; % right upper longitudinal
                5, 8; % right mid vertical
                6, 7; % left mid vertical
                5, 6; % mid lower lateral
                7, 8; % mid upper lateral
                1, 6; % lower front-mid diagonal
                1, 8; % right front-mid diagonal
                2, 7; % left front-mid diagonal
                3, 8; % upper front-mid diagonal
                % 5, 7; % left rear diagonal
                9, 8; % test extension
                9, 6; % test extension
                9, 7; % test extension
                6, 8; % test extension
                % 5, 9; % test extension
            ];
frame.fixed = [ 1, 1, 1, 1;
                2, 1, 0, 1;
                3, 1, 0, 0]; % fixed vertices
frame.loads = [9, 0, 0, -1]; % vertex, Fx, Fy, Fz

% frame.vertices = [ 0, 0, 0;
%                    0, 0, 1;
%                    0, 1, 1;
%                    1, 0, 1];
% frame.edges = [1, 4;
%                2, 4;
%                3, 4;
%                2, 3;
%                1, 2;
%                1, 3];
% frame.fixed = [ 1, 1, 1, 1;
%                 2, 1, 0, 0;
%                 3, 1, 0, 1]; % fixed vertices
% frame.loads = [4, 0, -0, 1]; % vertex, Fx, Fy, Fz

%% solve static equilibrium
[F_edges, F_reaction] = truss_sim(frame);

% plot results
% plot_frame(frame);
plot_frame(frame, F_edges, F_reaction);
