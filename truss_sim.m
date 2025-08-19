clear
close all
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

frame.fixed = [1, 2]; % fixed vertices
frame.loads = [3, 0, 0, 1]; % vertex, Fx, Fy, Fz

%% sanity checks
% number of dimensions check
if ~any(width(frame.vertices) == [2, 3])
    error('only 2D and 3D frames supported')
end

% dimension check
if length(frame.fixed) ~= (width(frame.loads)-1)
    error('more/less constraints than dimensions of simulation')
end

% force-constaint check
if any(frame.fixed == frame.loads(:, 1), 'all')
    error('external force applied on constrained vertex')
end

%% force calculation
% for each vertex, sum(internal forces from edges) + sum(external forces) = 0
% assumption: edge only carries compressive/tensile forces
% A*x + Fext = 0
% where x is vector of forces along each edge

% make matrix
A = zeros(height(frame.vertices), height(frame.edges), width(frame.vertices));
for idx_vert = 1:height(frame.vertices)
    % find index of all edges that connect to the edge
    idx_edges = find(any(frame.edges == idx_vert, 2))';

    for idx_edge = idx_edges
        % edge vector from vertex coordinates
        edge = diff(frame.vertices(frame.edges(idx_edge, :), :));
        
        % component of force in the edge (member) that acts in x,y,z direction
        F_ratio_edge = edge / norm(edge);
        
        % construct matrix
        A(idx_vert, idx_edge, :) = F_ratio_edge;
    end
end

% external forces
b = zeros(size(frame.vertices));
for fi = 1:height(frame.loads)
    b(frame.loads(fi, 1), :) = frame.loads(fi, 2:end); %TODO negative? 
end

%% reaction forces
% sum of forces, sum of moments = 0
% A*x = b
% x = vector of reaction forces in all dimensions
% x = [Fx1 Fy1 ...]'
% b = external forces, external moments = 0

Ar = zeros(width(frame.vertices)*2, width(frame.vertices)^2);
br = zeros(width(frame.vertices)^2 , 1);
% force sub-matrix
for di = 1:width(frame.vertices)
    for di2 = 1:width(frame.vertices)
        Ar(di, di + (di2-1)*width(frame.vertices)) = 1;
    end
end

% moment sub-matrix
% calculate moment of internal and external forces about vertex 1
for di = 2:width(frame.vertices)
    %TODO
end
return

% apply reaction forces to truss
%TODO

%% invert matrix for all directions individually
F_edges = nan(height(frame.edges), 3);
for di = 1:3
    F_edges(:, di) = A(:, :, di) \ b(:, di);
end

F_edges

%% plot frame
plot_frame(frame, b, F_edges);

