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

frame.fixed = [ 1, 1, 1, 1;
                2, 0, 1, 1;
                4, 0, 1, 0]; % fixed vertices

frame.loads = [3, 0, 0, 1]; % vertex, Fx, Fy, Fz

%% sanity checks
% number of dimensions check
if ~any(width(frame.vertices) == [2, 3])
    error('only 2D and 3D frames supported')
end

% dimension check
if height(frame.fixed) ~= (width(frame.loads)-1)
    error('more/less constraints than dimensions of simulation')
end

% force-constaint check
if any(frame.fixed(:, 1) == frame.loads(:, 1), 'all')
    error('external force applied on constrained vertex')
end

% condition for all constrained points being in the same line
if cross(diff(frame.vertices(frame.fixed(1:2, 1), :)), ...
         diff(frame.vertices(frame.fixed(2:3, 1), :))) == 0
    error('constrained points must not be collinear')
end

%% force calculation
% for each vertex, sum(internal forces from edges) - sum(external forces) = 0
% assumption: edge only carries compressive/tensile forces
% A*x = b
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
for fii = 1:height(frame.loads)
    b(frame.loads(fii, 1), :) = frame.loads(fii, 2:end);
end

%% reaction forces
% sum of forces, sum of moments = 0
% A*x = b
% x = vector of reaction forces in all dimensions
% x = [Fx1 Fy1 ...]'
% b = external forces, external moments

Ar = zeros(width(frame.vertices)^2, width(frame.vertices)^2);
br = zeros(width(frame.vertices)^2 , 1);
% force sub-matrix
for di = 1:width(frame.vertices)
    for di2 = 1:width(frame.vertices)
        Ar(di, di+(di2-1)*width(frame.vertices)) = 1;
    end
    br(di) = sum(frame.loads(:, di+1));
end

% moment sub-matrix
% moment about constrained vertex 1
v_con = frame.vertices(frame.fixed(1, 1), :);
moment = zeros(1, width(frame.vertices));
for ei = 1:height(frame.loads)
    moment_arm = frame.vertices(frame.loads(ei, 1), :) - v_con;
    force = frame.loads(ei, 2:end);
    moment = moment + cross(moment_arm, force);
end
br((1:width(frame.vertices))+width(frame.vertices)) = moment';

% calculate moment of reaction force on each constrained vertex about the first vertex
v_con = frame.vertices(frame.fixed(1, 1), :);
if width(frame.vertices) == 3
    con_count = 1;
    for di = 2:width(frame.vertices)
        % Mz = x*Fy - y*Fx
        % Mx = y*Fz - z*Fy
        % My = z*Fx - x*Fz
        %{
        M =    [0 -z  y;   [Fx
                z  0 -x; *  Fy
               -y  x  0] *  Fz]'
        %}
        moment_arm = frame.vertices(frame.fixed(di, 1), :) - v_con;
        Ar(4:6, (di-1)*width(frame.vertices)+1:di*width(frame.vertices)) = ...
            [0 -moment_arm(3) moment_arm(2);
             moment_arm(3) 0 -moment_arm(1);
            -moment_arm(2) moment_arm(1) 0];

        % zero force constraints based on support type
        for ci = find(~frame.fixed(di, 2:end))
            Ar(6+con_count, (di-1)*width(frame.vertices)+ci) = 1;
            con_count = con_count + 1;
        end
    end
elseif width(frame.vertices) == 2
    % for 2D
    %{
    M = Mz = x*Fy - y*Fx
    %}
    error('TODO moment calculation for 2D frames not implemented yet')
end
if rank(Ar) < height(Ar)
    error('matrix is singular, cannot solve for reaction forces. verify constraints')
end

% calculate reaction forces
F_reaction = Ar \ br; % reaction forces in x,y,z for all 3 constrained points

% apply reaction forces to truss
b2 = zeros(size(frame.vertices));
for fii = 1:height(frame.fixed) % vertex number
    for di = 1:(width(frame.fixed)-1) % dimension
        b2(frame.fixed(fii, 1), di) = F_reaction((fii-1)*(width(frame.fixed)-1)+di);
    end
end

b = b + b2;

%% invert matrix for all directions individually
F_edges = nan(height(frame.edges), 3);
for di = 1:3
    F_edges(:, di) = A(:, :, di) \ b(:, di);
end

%% plot frame
plot_frame(frame, b, F_edges);

