%% Verification Test Script

function test_crank_arm()
    fprintf('Running Verification Tests...\n');

    % Test Case: Al 6061-T6, 1500N, 170mm, 30mm
    mats = get_material_properties();
    al = mats(1, :); % Al 6061-T6

    F_max = 1500;
    F_min = 0;
    L = 170;
    D = 30;

    % 1. Stress Calculation Check
    [s_max, s_min, ~] = calculate_stress(F_max, F_min, L, D);
    % Hand calculation: M = 1500 * 0.170 = 255 N-m
    % I = pi * 0.03^4 / 64 = 3.976e-8 m^4
    % sigma = 255 * 0.015 / 3.976e-8 = 96.2 MPa
    expected_stress = 96.2;
    if abs(s_max - expected_stress) < 0.5
        fprintf('  [PASS] Stress Calculation (%.2f MPa)\n', s_max);
    else
        fprintf('  [FAIL] Stress Calculation (Got %.2f, Expected %.2f)\n', s_max, expected_stress);
    end

    % 2. Safety Factor Check
    sfs = calculate_safety_factors(s_max, s_min, al);
    % Al 6061-T6: Sy = 276, Su = 310, Se = 95
    % sigma_a = 96.2/2 = 48.1, sigma_m = 48.1
    % 1/n = 48.1/95 + 48.1/310 = 0.506 + 0.155 = 0.661
    % n = 1.51
    expected_sf = 1.51;
    if abs(sfs.Goodman - expected_sf) < 0.05
        fprintf('  [PASS] Goodman SF Calculation (%.2f)\n', sfs.Goodman);
    else
        fprintf('  [FAIL] Goodman SF Calculation (Got %.2f, Expected %.2f)\n', sfs.Goodman, expected_sf);
    end

    % 3. Optimization Check
    % If target SF is 1.5, and D=30 gives 1.51, opt_d should be close to 30.
    [opt_d, ~] = optimize_crank(F_max, F_min, L, al, 1.5, 'Goodman');
    if abs(opt_d - 30) < 1.0
        fprintf('  [PASS] Optimization Logic (Opt D = %.2f mm)\n', opt_d);
    else
        fprintf('  [FAIL] Optimization Logic (Opt D = %.2f mm)\n', opt_d);
    end

    fprintf('\nTests Completed.\n');
end
