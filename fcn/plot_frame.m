function plot_frame(frame, F_edges, F_reaction)
    %TODO plot internal and external forces
    % plot the frame structure defined by vertices and edges
    figure(123);
    clf
    hold on;
    cmap = colormap;
    for i = 1:size(frame.edges, 1)
        edge = frame.edges(i, :);
        col = getCol(cmap, [min(F_edges) max(F_edges)], F_edges(i));
        plot3(frame.vertices(edge, 1), ...
            frame.vertices(edge, 2), ...
            frame.vertices(edge, 3), ...
            'Color', col, 'LineWidth', 6);
    end
    for i = 1:size(frame.vertices, 1)
        scatter3(frame.vertices(i, 1), frame.vertices(i, 2), frame.vertices(i, 3), 200, 'k', 'filled');
    end
    colorbar('Ticks',linspace(min(F_edges), max(F_edges), 5));
    axis equal;
    grid on;
    title('Frame Structure');
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    view([45 45])
    daspect([1 1 1]);
    % plot constraints by dimension
    xl = range(xlim)*0.05;
    % yl = range(ylim)*0.05;
    % zl = range(zlim)*0.05;

    for i = 1:size(frame.fixed, 1)
        vert = frame.fixed(i, 1);
        is_fixed = frame.fixed(i, 2:end);
        for di = 1:(width(frame.fixed)-1)
            if ~is_fixed(di)
                continue
            end
            plot3(frame.vertices(vert, 1)+[-1 1]*xl*(di==1), ...
                  frame.vertices(vert, 2)+[-1 1]*xl*(di==2), ...
                  frame.vertices(vert, 3)+[-1 1]*xl*(di==3), ...
                'k', 'MarkerSize', 8, 'LineWidth', 2);
        end
    end

    % plot external forces
    sc = 0.25;
    for i = 1:size(frame.loads, 1)
        vert = frame.loads(i, 1);
        quiver3(frame.vertices(vert, 1), ...
            frame.vertices(vert, 2), ...
            frame.vertices(vert, 3), ...
            frame.loads(i, 2)*sc, ...
            frame.loads(i, 3)*sc, ...
            frame.loads(i, 4)*sc, ...
            'b', 'LineWidth', 2, 'MaxHeadSize', 2);
    end

    % plot reaction forces
    sc = 0.25;
    for i = 1:size(frame.fixed, 1)
        vert = frame.fixed(i, 1);
        quiver3(frame.vertices(vert, 1), ...
            frame.vertices(vert, 2), ...
            frame.vertices(vert, 3), ...
            F_reaction((i-1)*3+1)*sc, ...
            F_reaction((i-1)*3+2)*sc, ...
            F_reaction((i-1)*3+3)*sc, ...
            'r', 'LineWidth', 2, 'MaxHeadSize', 2);
    end

end

function col = getCol(cols, rng, val)
    col = nan(1, 3);
    for i = 1:3
        col(i) = interp1(linspace(rng(1), rng(2), height(cols)), cols(:, i), val, 'linear', 'extrap');
    end
end
