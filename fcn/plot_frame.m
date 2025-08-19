function plot_frame(frame, F_edges, F_reaction)
    %TODO plot internal and external forces
    % plot the frame structure defined by vertices and edges
    figure(123);
    clf
    hold on;
    cmap = colormap('turbo');
    if nargin < 2
        F_edges = zeros(size(frame.edges, 1), 1);
    end
    for i = 1:size(frame.edges, 1)
        edge = frame.edges(i, :);
        col = getCol(cmap, [-1 1]*max(abs(F_edges)), F_edges(i));
        p = plot3(frame.vertices(edge, 1), ...
            frame.vertices(edge, 2), ...
            frame.vertices(edge, 3), ...
            'Color', col, 'LineWidth', 6, 'HandleVisibility', 'off');
    end
    r = dataTipTextRow('Index', 1:numel(frame.vertices));
    p.DataTipTemplate.DataTipRows(end+1) = r;

    for i = 1:size(frame.vertices, 1)
        s = scatter3(frame.vertices(i, 1), frame.vertices(i, 2), frame.vertices(i, 3), 200, 'k', 'filled', 'DisplayName', 'Vertices');
        if i ~= 1
            s.HandleVisibility = 'off';
        end
        text(frame.vertices(i, 1), frame.vertices(i, 2), frame.vertices(i, 3), ...
            sprintf('  %d', i), 'FontSize', 20, 'Color', 'r');
    end
    if nargin > 1
        c = colorbar('Ticks', (0:4)/4, 'TickLabels',linspace(-max(abs(F_edges)), max(abs(F_edges)), 5));
        c.Label.String = 'Internal Force (N) (+ve = Tension)';
    end
    axis equal;
    grid on;
    title('Frame Structure');
    xlabel('X-axis (m)');
    ylabel('Y-axis (m)');
    zlabel('Z-axis (m)');
    view([45 45])
    daspect([1 1 1]);

    % plot constraints by dimension
    xl = range(xlim)*0.08;

    for i = 1:size(frame.fixed, 1)
        vert = frame.fixed(i, 1);
        is_fixed = frame.fixed(i, 2:end);
        for di = 1:(width(frame.fixed)-1)
            if ~is_fixed(di)
                continue
            end
            p = plot3(frame.vertices(vert, 1)+[-1 1]*xl*(di==1), ...
                  frame.vertices(vert, 2)+[-1 1]*xl*(di==2), ...
                  frame.vertices(vert, 3)+[-1 1]*xl*(di==3), ...
                'k', 'MarkerSize', 8, 'LineWidth', 4, 'DisplayName', 'Constraints');
            if di ~= 1 || i ~= 1
                p.HandleVisibility = 'off';
            end
        end
    end

    % plot external forces
    sc = 0.1;
    for i = 1:size(frame.loads, 1)
        vert = frame.loads(i, 1);
        q = quiver3(frame.vertices(vert, 1), ...
            frame.vertices(vert, 2), ...
            frame.vertices(vert, 3), ...
            frame.loads(i, 2)*sc, ...
            frame.loads(i, 3)*sc, ...
            frame.loads(i, 4)*sc, ...
            'b', 'LineWidth', 4, 'MaxHeadSize', 2/norm(frame.loads(i, 2:end)), 'DisplayName', 'External forces');
        if i ~= 1
            q.HandleVisibility = 'off';
        end
    end

    % plot reaction forces
    if nargin > 2
        sc = 0.1;
        for i = 1:size(frame.fixed, 1)
            vert = frame.fixed(i, 1);
            q = quiver3(frame.vertices(vert, 1), ...
                frame.vertices(vert, 2), ...
                frame.vertices(vert, 3), ...
                F_reaction(i, 1)*sc, ...
                F_reaction(i, 2)*sc, ...
                F_reaction(i, 3)*sc, ...
                'r', 'LineWidth', 4, 'MaxHeadSize', 2/norm(F_reaction(i, :)), 'DisplayName', 'Reaction forces');
            if i ~= 1
                q.HandleVisibility = 'off';
            end
        end
    end
    legend('show', 'Location', 'best')
end

function col = getCol(cols, rng, val)
    col = nan(1, 3);
    if range(rng) == 0
        col = cols(1, :);
    else
        for i = 1:3
            col(i) = interp1(linspace(rng(1), rng(2), height(cols)), cols(:, i), val, 'linear', 'extrap');
        end
    end
end
