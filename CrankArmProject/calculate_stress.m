function [stress_max, stress_min, stress_vm] = calculate_stress(force_max, force_min, crank_len, diameter)
    % CALCULATE_STRESS Computes maximum, minimum, and Von Mises stress for a crank arm.

    % Convert to meters for calculation
    L = crank_len / 1000;
    d = diameter / 1000;

    % Bending moments (N-m)
    M_max = force_max * L;
    M_min = force_min * L;

    % Second moment of inertia (m^4) for solid circular cross-section
    I = (pi * d^4) / 64;

    % Radius (m)
    c = d / 2;

    % Bending stress (Pa -> MPa)
    stress_max = (M_max * c / I) / 1e6;
    stress_min = (M_min * c / I) / 1e6;

    % For pure bending on a circular section, Von Mises = Peak Bending Stress
    stress_vm = abs(stress_max);
end
