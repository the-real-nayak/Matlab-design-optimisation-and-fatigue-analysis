function [opt_diameter, opt_weight] = optimize_crank(force_max, force_min, length, material_props, target_sf, criterion)
    % OPTIMIZE_CRANK Finds the minimum diameter to satisfy a safety factor.
    %
    % Inputs:
    %   force_max, force_min: Pedaling forces (N)
    %   length: Crank arm length (mm)
    %   material_props: Material properties table row
    %   target_sf: Required safety factor (e.g., 1.5)
    %   criterion: 'Goodman', 'Soderberg', 'Gerber', or 'VonMises'

    % Objective function: Minimize weight (proportional to diameter^2)
    % Weight = density * pi * (d/2)^2 * L
    density = material_props.Density;
    L_m = length / 1000;

    obj_fun = @(d) (density * pi * (d/1000/2)^2 * L_m);

    % Constraint function: sf >= target_sf  =>  target_sf - sf <= 0
    nonlcon = @(d) crank_constraints(d, force_max, force_min, length, material_props, target_sf, criterion);

    % Optimization parameters
    d0 = 30; % Initial guess (mm)
    lb = 5;  % Lower bound (mm)
    ub = 100; % Upper bound (mm)

    options = optimoptions('fmincon', 'Display', 'none');

    [opt_diameter, opt_weight] = fmincon(obj_fun, d0, [], [], [], [], lb, ub, nonlcon, options);
end

function [c, ceq] = crank_constraints(d, force_max, force_min, length, material_props, target_sf, criterion)
    [s_max, s_min, ~] = calculate_stress(force_max, force_min, length, d);
    sf_struct = calculate_safety_factors(s_max, s_min, material_props);

    % Current safety factor for the chosen criterion
    current_sf = sf_struct.(criterion);

    % target_sf - current_sf <= 0
    c = target_sf - current_sf;
    ceq = [];
end
