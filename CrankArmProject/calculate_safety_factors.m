function sf = calculate_safety_factors(stress_max, stress_min, material_props)
    % CALCULATE_SAFETY_FACTORS Computes safety factors for various criteria.
    %
    % Inputs:
    %   stress_max: Max bending stress (MPa)
    %   stress_min: Min bending stress (MPa)
    %   material_props: Struct or row table with YieldStrength, UltimateStrength, EnduranceLimit
    %
    % Output:
    %   sf: Struct containing safety factors for Goodman, Soderberg, Gerber, Von Mises, and Tresca.

    sigma_y = material_props.YieldStrength;
    sigma_u = material_props.UltimateStrength;
    sigma_e = material_props.EnduranceLimit;

    % Alternating and Mean Stress
    sigma_a = abs(stress_max - stress_min) / 2;
    sigma_m = (stress_max + stress_min) / 2;

    % 1. Static Failure (Von Mises)
    % Assuming peak stress is the max bending stress
    sf.VonMises = sigma_y / abs(stress_max);

    % 2. Static Failure (Tresca)
    % For pure bending, max shear = 0.5 * sigma_max
    % sf_tresca = (sigma_y / 2) / (sigma_max / 2) = sigma_y / sigma_max
    sf.Tresca = sigma_y / abs(stress_max);

    % 3. Fatigue - Goodman
    % 1/n = sigma_a/sigma_e + sigma_m/sigma_u
    sf.Goodman = 1 / (sigma_a/sigma_e + sigma_m/sigma_u);

    % 4. Fatigue - Soderberg
    % 1/n = sigma_a/sigma_e + sigma_m/sigma_y
    sf.Soderberg = 1 / (sigma_a/sigma_e + sigma_m/sigma_y);

    % 5. Fatigue - Gerber
    % 1/n = sigma_a/sigma_e + (sigma_m/sigma_u)^2
    sf.Gerber = 1 / (sigma_a/sigma_e + (sigma_m/sigma_u)^2);

    % Handle potential negative or infinite safety factors (e.g. sigma_m > sigma_u)
    fnames = fieldnames(sf);
    for i = 1:numel(fnames)
        if sf.(fnames{i}) <= 0
            sf.(fnames{i}) = 0; % Failure
        elseif isinf(sf.(fnames{i}))
            sf.(fnames{i}) = 999; % Very safe
        end
    end
end
