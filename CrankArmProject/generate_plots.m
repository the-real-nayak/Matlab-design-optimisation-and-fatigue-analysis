function generate_plots(force_max, crank_len, diameter, target_sf, primary_mat, comparison_mats, export_path)
    % GENERATE_PLOTS Comprehensive Design Engineer Gallery
    % Generates 7 high-value charts for sensitivity and efficiency analysis.

    gallery_path = fullfile(export_path, 'Sensitivity_2D_Plots');
    if ~exist(gallery_path, 'dir'), mkdir(gallery_path); end

    % Define Sweep Ranges
    R.Force = linspace(500, 3500, 25);
    R.Length = linspace(140, 210, 25);
    R.Diameter = linspace(10, 55, 25);

    % Combined Materials List
    all_plot_mats = [primary_mat; comparison_mats];
    num_p_mats = height(all_plot_mats);
    colors = lines(num_p_mats);

    fprintf('Generating 7-Chart Design Engineering Gallery...\n');

    % --- 1. Safety Sizing Tool (SF vs Diameter) ---
    f1 = figure('Visible', 'off'); hold on;
    for m = 1:num_p_mats
        sfs = zeros(size(R.Diameter));
        for i = 1:length(R.Diameter)
            [smx, ~, ~] = calculate_stress(force_max, 0, crank_len, R.Diameter(i));
            sf = calculate_safety_factors(smx, 0, all_plot_mats(m,:));
            sfs(i) = sf.Goodman;
        end
        plot(R.Diameter, sfs, 'Color', colors(m,:), 'LineWidth', 2, 'DisplayName', all_plot_mats.Name{m});
    end
    yline(target_sf, 'r:', ['Target SF=', num2str(target_sf)], 'LineWidth', 1.5, 'HandleVisibility', 'off');
    grid on; title('Safety Sizing Tool: Goodman SF vs Diameter');
    xlabel('Crank Diameter (mm)'); ylabel('Goodman Safety Factor');
    legend('show', 'Location', 'best', 'Interpreter', 'none');
    saveas(f1, fullfile(gallery_path, '01_SF_vs_Diameter_Comparison.png'));

    % --- 2. Load Sensitivity (SF vs Rider Force) ---
    f2 = figure('Visible', 'off'); hold on;
    for m = 1:num_p_mats
        sfs = zeros(size(R.Force));
        for i = 1:length(R.Force)
            [smx, ~, ~] = calculate_stress(R.Force(i), 0, crank_len, diameter);
            sf = calculate_safety_factors(smx, 0, all_plot_mats(m,:));
            sfs(i) = sf.Goodman;
        end
        plot(R.Force, sfs, 'Color', colors(m,:), 'LineWidth', 2, 'DisplayName', all_plot_mats.Name{m});
    end
    yline(1.0, 'k--', 'Failure (SF=1.0)', 'HandleVisibility', 'off');
    grid on; title('Load Sensitivity: Design Reliability vs Rider Force');
    xlabel('Applied Force (N)'); ylabel('Goodman SF');
    legend('show', 'Location', 'best', 'Interpreter', 'none');
    saveas(f2, fullfile(gallery_path, '02_SF_vs_Force_Comparison.png'));

    % --- 3. Optimization Map (Required Size vs Force) ---
    f3 = figure('Visible', 'off'); hold on;
    for m = 1:num_p_mats
        req_d = zeros(size(R.Force));
        for i = 1:length(R.Force)
            [req_d(i), ~] = optimize_crank(R.Force(i), 0, crank_len, all_plot_mats(m,:), target_sf, 'Goodman');
        end
        plot(R.Force, req_d, 'Color', colors(m,:), 'LineWidth', 2, 'DisplayName', all_plot_mats.Name{m});
    end
    grid on; title(['Minimum Required Diameter for SF=', num2str(target_sf)]);
    xlabel('Rider Force (N)'); ylabel('Required Diameter (mm)');
    legend('show', 'Location', 'best', 'Interpreter', 'none');
    saveas(f3, fullfile(gallery_path, '03_Required_Size_vs_Force.png'));

    % --- 4. Weight Penalty Map (Weight vs Diameter) ---
    f4 = figure('Visible', 'off'); hold on;
    for m = 1:num_p_mats
        weights = zeros(size(R.Diameter));
        for i = 1:length(R.Diameter)
            weights(i) = all_plot_mats.Density(m) * pi * (R.Diameter(i)/2000)^2 * (crank_len/1000);
        end
        plot(R.Diameter, weights, 'Color', colors(m,:), 'LineWidth', 2, 'DisplayName', all_plot_mats.Name{m});
    end
    grid on; title('Weight Penalty: Mass vs Component Size');
    xlabel('Crank Diameter (mm)'); ylabel('Weight (kg)');
    legend('show', 'Location', 'best', 'Interpreter', 'none');
    saveas(f4, fullfile(gallery_path, '04_Weight_vs_Diameter_Comparison.png'));

    % --- 5. Leverage Sensitivity (SF vs Crank Length) ---
    f5 = figure('Visible', 'off'); hold on;
    for m = 1:num_p_mats
        sfs_l = zeros(size(R.Length));
        for i = 1:length(R.Length)
            [smx, ~, ~] = calculate_stress(force_max, 0, R.Length(i), diameter);
            sf = calculate_safety_factors(smx, 0, all_plot_mats(m,:));
            sfs_l(i) = sf.Goodman;
        end
        plot(R.Length, sfs_l, 'Color', colors(m,:), 'LineWidth', 2, 'DisplayName', all_plot_mats.Name{m});
    end
    grid on; title('Leverage Sensitivity: Safety vs Crank Length');
    xlabel('Crank Length (mm)'); ylabel('Goodman SF');
    legend('show', 'Location', 'best', 'Interpreter', 'none');
    saveas(f5, fullfile(gallery_path, '05_SF_vs_Length_Comparison.png'));

    % --- 6. Design Envelope: Max Safe Load vs Diameter ---
    f6 = figure('Visible', 'off'); hold on;
    for m = 1:num_p_mats
        max_f = zeros(size(R.Diameter));
        for i = 1:length(R.Diameter)
            % Reverse the stress formula to find Force for SF=Target
            sigma_limit = (all_plot_mats.UltimateStrength(m) + all_plot_mats.EnduranceLimit(m))/2 / target_sf;
            max_f(i) = (sigma_limit * 1e6 * pi * (R.Diameter(i)/1000)^3) / (32 * (crank_len/1000));
        end
        plot(R.Diameter, max_f, 'Color', colors(m,:), 'LineWidth', 2, 'DisplayName', all_plot_mats.Name{m});
    end
    grid on; title(['Design Envelope: Max Safe Rider Force (SF=', num2str(target_sf), ')']);
    xlabel('Crank Diameter (mm)'); ylabel('Max Safe Load (N)');
    legend('show', 'Location', 'best', 'Interpreter', 'none');
    saveas(f6, fullfile(gallery_path, '06_Load_Capacity_Envelope.png'));

    % --- 7. Material Efficiency: Specific Strength (Selected Mats Only) ---
    f7 = figure('Visible', 'off');
    eff = (all_plot_mats.UltimateStrength) ./ (all_plot_mats.Density ./ 1000); % MPa / (g/cm3 equivalent)
    bar(categorical(all_plot_mats.Name), eff);
    grid on; ylabel('Specific Strength (Efficiency Unit)');
    title('Material Efficiency Comparison (Strength-to-Weight Ratio)');
    saveas(f7, fullfile(gallery_path, '07_Material_Efficiency_Rank.png'));

    fprintf('Full Design Engineering Gallery Complete (7 Charts).\n');
    close all;
end
