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
                    -0.4, 0.2, 0.25;
                    -0.4, 0,   0.25;

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
            ];

frame.stiffness = ones(height(frame.edges));

frame.fixed = [ 1, 1, 1, 1;
                2, 0, 1, 1;
                4, 0, 1, 0]; % fixed vertices

frame.loads = [7, 0, 0, 1]; % vertex, Fx, Fy, Fz
plot_frame(frame)

%% solve static equilibrium
[F_edges, F_reaction] = truss_sim(frame);
F_edges = sqrt(sum(F_edges.^2, 2));

%% plot results
plot_frame(frame, F_edges, F_reaction);
