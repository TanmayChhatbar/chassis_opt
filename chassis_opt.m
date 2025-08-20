clear
clc
addpath('fcn');

%% define frame
frame.vertices = [  0, 0, 0;
                    1, 0, 0;
                    1, 0, 1;
                    0, 0, 1
                ];

frame.edges = [ 1, 2;
                2, 3;
                3, 4;
                4, 1;
                1, 3
            ];

frame.fixed = [ 1, 1, 1, 1;
                2, 0, 1, 1;
                4, 0, 1, 0]; % fixed vertices

frame.loads = [3, 0, 0, 1]; % vertex, Fx, Fy, Fz

%% solve static equilibrium
[F_edges, F_reaction] = truss_sim(frame);
F_edges = sqrt(sum(F_edges.^2, 2));

%% plot results
plot_frame(frame, F_edges, F_reaction);
