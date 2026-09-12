%% Functions for time-domain and s-domain analysis
% Inputs: 2 transfer functions, given as arrays of numerator/denominator coefficients (descending powers)
% We define functions to get the following: 
% - Generate time-domain step response plot (transient response)
% - Generate s-domain pole-zero plot
% - Print the transient response parameters (PO, td, tr, ts, ess)
% - Print the s-domain parameters (wn, zeta) for each complex conjugate pole pair

NUM1 = [12614 214438 2018240 6307000];
DEN1 = [5 95 1135 6915 22385 63070];
NUM2 = [1700];
DEN2 = [1 2 17];

function [S1, S2] = plot_step_response(n1, d1, n2, d2)
    sys1 = tf(n1, d1);
    sys2 = tf(n2, d2);
    % Use stepplot function provided by Control System Toolbox (unit step response)
    figure;
    stepplot(sys1, sys2);
    set(gcf, 'Color', 'w')
    grid;
    legend('5th Order System', '2nd Order Approximation');
    hold;
    yss = n1(end) / d1(end);
    yline([yss*0.9 yss yss*1.1], '--', {'0.9y_{ss}', 'y_{ss}', '1.1y_{ss}'}, ...
        'HandleVisibility', 'off', 'Color', '#000000');
    [y1, t1] = step(sys1);
    [y2, t2] = step(sys2);
    [ymax1, tpeak1] = max(y1);
    [ymax2, tpeak2] = max(y2);
    yline(ymax1, 'LineStyle', '-.', 'HandleVisibility', 'off', 'Color', '#1171BE', ...
        'Label', sprintf('%.1f', ymax1), ...
        'LabelHorizontalAlignment', 'left', 'LabelVerticalAlignment', 'middle');
    yline(ymax2, 'LineStyle', '-.', 'HandleVisibility', 'off', 'Color', '#DD5400', ...
        'Label', sprintf('%.1f', ymax2), ...
        'LabelHorizontalAlignment', 'left', 'LabelVerticalAlignment', 'middle');
    xline(t1(tpeak1), 'LineStyle', '-.', 'Color', '#1171BE', 'HandleVisibility', 'off', ...
        'Label', sprintf('%.3f', t1(tpeak1)), ...
        'LabelHorizontalAlignment', 'left', 'LabelVerticalAlignment', 'bottom');
    xline(t2(tpeak2), 'LineStyle', '-.', 'Color', '#DD5400', 'HandleVisibility', 'off', ...
        'Label', sprintf('%.3f', t2(tpeak2)), ...
        'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom');
    plot(t1(tpeak1), ymax1, 'Marker', '.', 'Color', '#1171BE', 'HandleVisibility', 'off');
    plot(t2(tpeak2), ymax2, 'Marker', '.', 'Color', '#DD5400', 'HandleVisibility', 'off');
    % Get step response time parameters (with settling time defined as +-10% threshold)
    S1 = stepinfo(y1, t1, SettlingTimeThreshold=0.1);
    S2 = stepinfo(y2, t2, SettlingTimeThreshold=0.1);
    % Calculate delay times and add to step info structs
    delay1 = find(y1 >= 0.5*yss, 1, 'first');
    delay2 = find(y2 >= 0.5*yss, 1, 'first');
    S1.DelayTime = t1(delay1);
    S2.DelayTime = t2(delay2);

end

function plot_poles_zeros(n1, d1, d2)
    % Note: no need to pass in numerator of the second-order function (as there are no zeros)
    zeros = roots(n1);
    poles = roots(d1);
    dominantpoles = roots(d2);
    % Create a new figure so that the time-domain plot can be accessed separately
    figure;
    title({'Pole-Zero Plot', ''}); % Empty string in cell array adds vertical padding
    set(gcf, 'Color', 'w')
    xlabel('\sigma');
    ylabel('j\omega');
    grid;
    % Move axes to pass through the origin
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    axis equal;
    % Change figure limits to square
    max_extent = max(abs(poles))+1;
    xlim([-max_extent max_extent]);
    ylim([-max_extent max_extent]);
    % Plot poles and zeros with appropriate markers
    hold on;
    plot(real(poles), imag(poles), 'bx', 'MarkerSize', 9, 'LineWidth', 1);
    plot(real(zeros), imag(zeros), 'bo', 'MarkerSize', 7, 'LineWidth', 1);
    plot(real(dominantpoles), imag(dominantpoles), 'rx', 'MarkerSize', 9, 'LineWidth', 1);
    legend('Poles', 'Zeros', 'Dominant Poles')
    % Add coordinate labels to all points
    poi = [zeros; poles];
    signs = repmat("+", size(poi));
    signs(imag(poi) < 0) = "-";
    labels = compose("%.0f%sj%.0f", real(poi), signs, abs(imag(poi)));
    text(real(poi), imag(poi)+1, labels, 'HorizontalAlignment', 'center', 'FontSize', 10);
end

fprintf("Higher order transfer function:")
T_s = tf(NUM1, DEN1)

fprintf("Simplified lower order transfer function:")
Tdp_s = tf(NUM2, DEN2)

% Plot step response and print time parameters
[S1, S2] = plot_step_response(NUM1, DEN1, NUM2, DEN2)

% Plot locations of poles and zeros
plot_poles_zeros(NUM1, DEN1, DEN2)