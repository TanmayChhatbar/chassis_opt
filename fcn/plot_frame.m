function plot_frame(frame, F_edges)
    %TODO plot internal and external forces
    % plot the frame structure defined by vertices and edges
    figure;
    hold on;
    for i = 1:size(frame.edges, 1)
        edge = frame.edges(i, :);
        plot3(frame.vertices(edge, 1), ...
            frame.vertices(edge, 2), ...
            frame.vertices(edge, 3), ...
            'k-', 'LineWidth', 2);
    end
    axis equal;
    grid on;
    title('Frame Structure');
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    hold off;
end
