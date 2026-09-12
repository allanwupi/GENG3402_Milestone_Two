%% Work in Progress - Allan Wu (23810308)

%% Define transfer function
% This section uses MATLAB Symbolic Math toolbox to generate coefficients of polynomials.
% It should be removed before the submission, once we decide on the transfer function to use.
% Edit these expressions to try different transfer functions: DOMINANT_POLES, HIGHER_ORDER_POLES, ZEROS

% Set DC gain (set this to 1 to easily read percentage overshoot)
DC_GAIN = 100;
syms s
% Set dominant poles (complex conjugate pair)
DOMINANT_POLES = (s+1-4j) * (s+1+4j);
% Add nondominant poles for higher-order transfer function
HIGHER_ORDER_POLES = (s+10) * (s+7) * (s+5-9j) * (s+5+9j) ...
    * DOMINANT_POLES;
% Add zeros into higher-order transfer function
ZEROS = (s+6+8j) * (s+6-8j) * (s+5);

K = 1/DC_GAIN * (subs(expand(ZEROS), s, 0) / subs(expand(HIGHER_ORDER_POLES), s, 0));
denominator1 = sym2poly(K * expand(HIGHER_ORDER_POLES));
numerator1 = sym2poly(expand(ZEROS));

denominator2 = sym2poly(expand(DOMINANT_POLES));
numerator2 = sym2poly(DC_GAIN * denominator2(end) + 0*s);


%% Functions for time-domain and s-domain analysis
% Inputs: 2 transfer functions, given as arrays of numerator/denominator coefficients (descending powers)
% We define functions to get the following: 
% - Generate time-domain step response plot (transient response)
% - Generate s-domain pole-zero plot
% - Print the transient response parameters (PO, td, tr, ts, ess)
% - Print the s-domain parameters (wn, zeta) for each complex conjugate pole pair

function plot_step_response(n1, d1, n2, d2)
    sys1 = tf(n1, d1);
    sys2 = tf(n2, d2);
    % Use stepplot function provided by Control System Toolbox (unit step response)
    figure;
    stepplot(sys1, sys2);
    grid;
    legend('Higher Order System', 'Dominant Poles Approximation');
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
end

function plot_poles_zeros(n1, d1, d2)
    % Note: no need to pass in numerator of the second-order function (as there are no zeros)
    zeros = roots(n1);
    poles = roots(d1);
    dominantpoles = roots(d2);
    % Create a new figure so that the time-domain plot can be accessed separately
    figure;
    title({'Pole-Zero Plot', ''}); % Empty string in cell array adds vertical padding
    xlabel('\sigma');
    ylabel('j\omega');
    grid;
    % Move axes to pass through the origin
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
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

function get_transient_parameters(n1, d1, n2, d2)
    sys1 = tf(n1, d1);
    sys2 = tf(n2, d2);
    fprintf("NOT IMPLEMENTED")
end

function get_s_domain_parameters(n1, d1, n2, d2)
    sys1 = tf(n1, d1);
    sys2 = tf(n2, d2);
    fprintf("NOT IMPLEMENTED")
end

fprintf("Higher order transfer function:")
T_s = tf(numerator1, denominator1)

fprintf("Simplified lower order transfer function:")
Tdp_s = tf(numerator2, denominator2)

% Call functions
plot_step_response(numerator1, denominator1, numerator2, denominator2)
plot_poles_zeros(numerator1, denominator1, denominator2)