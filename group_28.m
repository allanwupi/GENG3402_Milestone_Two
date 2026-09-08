%% Work in Progress - Allan Wu (23810308)

%% Define transfer function
% This section uses MATLAB Symbolic Math toolbox to generate coefficients of polynomials.
% It should be removed before the submission, once we decide on the transfer function to use.
% Edit these expressions to try different transfer functions: DOMINANT_POLES, HIGHER_ORDER_POLES, ZEROS

syms s
% Set dominant poles (complex conjugate pair)
DOMINANT_POLES = (s+1-8j) * (s+1+8j);
% Add nondominant poles for higher-order transfer function
HIGHER_ORDER_POLES = (s+7) * (s+6-9j) * (s+6+9j) ...
    * DOMINANT_POLES;
% Add zeros into higher-order transfer function
ZEROS = (s+10);

expanded_ho = expand(HIGHER_ORDER_POLES);
expanded_dp = expand(DOMINANT_POLES);
expanded_zeros = expand(ZEROS);

denominator1 = sym2poly(expanded_ho);
denominator2 = sym2poly(expanded_dp);
numerator1 = sym2poly(expanded_zeros);
% Match DC gain of higher-order system
DC_gain = subs(expanded_zeros, s, 0) / subs(expanded_ho, s, 0);
numerator2 = sym2poly(DC_gain * denominator2(end));


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
    stepplot(sys1, sys2)
    legend('Higher Order System', 'Dominant Poles Approximation');
    grid;
    % TODO: Label the plot better...
end

function plot_poles_zeros(n1, d1, d2)
    % Note: no need to pass in numerator of the second-order function (as there are no zeros)
    zeros = roots(n1);
    poles = roots(d1);
    dominantpoles = roots(d2);
    % Create a new figure so that the time-domain plot can be accessed separately
    figure;
    title('Poles and Zeros');
    xlabel('\sigma');
    ylabel('j\omega');
    grid;
    % Move axes to pass through the origin
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    % Change figure limits to square
    max_extent = max(abs(poles));
    xlim([-max_extent max_extent]);
    ylim([-max_extent max_extent]);
    % Plot poles and zeros with appropriate markers
    hold on;
    plot(real(zeros), imag(zeros), 'ro', 'MarkerSize', 10, 'LineWidth', 1);
    plot(real(poles), imag(poles), 'rx', 'MarkerSize', 10, 'LineWidth', 1);
    plot(real(dominantpoles), imag(dominantpoles), 'bx', 'MarkerSize', 10, 'LineWidth', 1);
    legend('Poles', 'Zeros', 'Dominant Poles')
    % Add coordinate labels to all points
    poi = [zeros; poles; dominantpoles];
    labels = compose("%.1f + j%.1f", real(poi), imag(poi));
    text(real(poi), imag(poi)+0.75, labels, 'HorizontalAlignment', 'center', 'FontSize', 10);
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
