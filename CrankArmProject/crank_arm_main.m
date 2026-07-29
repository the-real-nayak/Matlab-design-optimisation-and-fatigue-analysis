%% Bicycle Crank Arm Fatigue Analysis & Optimization
% Final Integrated Design Tool: Multi-Material + Optimization + Constraints

clear; clc; close all;

%% 1. Configuration & Paths
root_results_path = 'C:\Users\krish\Desktop\Crank_arm_results';
timestamp = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
export_path = fullfile(root_results_path, ['Test-', timestamp]);

if ~exist(export_path, 'dir'), mkdir(export_path); end

fprintf('====================================================\n');
fprintf('  Bicycle Crank Arm Fatigue Analysis & Optimization  \n');
fprintf('====================================================\n\n');

%% 2. User Inputs: Primary Parameters
materials = get_material_properties();
num_mats = height(materials);

fprintf('--- STEP 1: DEFINE DESIGN PARAMETERS ---\n');
for i = 1:num_mats
    fprintf('%2d. %-30s', i, materials.Name{i});
    if mod(i, 2) == 0, fprintf('\n'); end
end
if mod(num_mats, 2) ~= 0, fprintf('\n'); end

primary_idx = input('\nSelect Primary Material index (Default 9): ');
if isempty(primary_idx), primary_idx = 9; end
primary_material = materials(primary_idx, :);

force_max = input('Max Pedaling Force (N, Default 1500): ');
if isempty(force_max), force_max = 1500; end

crank_len = input('Crank Length (mm, Default 170): ');
if isempty(crank_len), crank_len = 170; end

crank_diam = input('Baseline Diameter (mm, Default 30): ');
if isempty(crank_diam), crank_diam = 30; end

target_sf = input('Target Safety Factor (Default 1.5): ');
if isempty(target_sf), target_sf = 1.5; end

%% 3. Comparison Selection
fprintf('\n--- STEP 2: MULTI-MATERIAL COMPARISON ---\n');
comp_ids = input('Enter indices of other materials to compare (e.g. [4, 14, 32], or leave blank): ');
comparison_mats = materials(comp_ids, :);

%% 4. Constraint Selection for Optimization & Analysis
fprintf('\n--- STEP 3: DEFINE FIXED CONSTANTS & OPTIMIZATION ---\n');
fprintf('Enter 1 to keep FIXED, 0 to keep VARIABLE (Varying triggers optimization/plots).\n');

fixed_force = input('Keep Force Constant? (0/1, Default 1): ');
if isempty(fixed_force), fixed_force = 1; end

fixed_len = input('Keep Length Constant? (0/1, Default 1): ');
if isempty(fixed_len), fixed_len = 1; end

fixed_diam = input('Keep Diameter Constant? (0/1, Default 1): ');
if isempty(fixed_diam), fixed_diam = 1; end

fixed_vars = [fixed_force, fixed_len, fixed_diam];

%% 5. Execution: Analysis & Optimization Reports
fprintf('\n--- STEP 4: ENGINEERING PERFORMANCE REPORT ---\n');

% Baseline for ALL chosen materials
all_selected_mats = [primary_material; comparison_mats];
fprintf('\n[BASELINE ANALYSIS at D=%.1fmm, F=%.1fN]\n', crank_diam, force_max);
fprintf('%-30s | %-12s | %-8s\n', 'Material', 'Stress (MPa)', 'Goodman SF');
fprintf('--------------------------------------------------------------\n');

for m = 1:height(all_selected_mats)
    [s_max, ~, ~] = calculate_stress(force_max, 0, crank_len, crank_diam);
    sfs_res = calculate_safety_factors(s_max, 0, all_selected_mats(m,:));
    fprintf('%-30s | %-12.2f | %-8.2f\n', all_selected_mats.Name{m}, s_max, sfs_res.Goodman);
end

% Optimization Report (if Diameter is Variable)
if fixed_diam == 0
    fprintf('\n[WEIGHT OPTIMIZATION REPORT (SF Target: %.1f)]\n', target_sf);
    fprintf('%-30s | %-15s | %-12s\n', 'Material', 'Opt. Diam (mm)', 'Weight (kg)');
    fprintf('--------------------------------------------------------------\n');
    for m = 1:height(all_selected_mats)
        [opt_d, opt_w] = optimize_crank(force_max, 0, crank_len, all_selected_mats(m,:), target_sf, 'Goodman');
        fprintf('%-30s | %-15.2f | %-12.4f\n', all_selected_mats.Name{m}, opt_d, opt_w);
    end
end

%% 6. Global Multi-Material Plotting (Exhaustive 2D)
fprintf('\n--- STEP 5: GENERATING SENSITIVITY GRAPHS ---\n');
generate_plots(force_max, crank_len, crank_diam, target_sf, primary_material, comparison_mats, export_path);

% Export Results to Excel
results_table = table({'Primary Material'; 'Max Force (N)'; 'Crank Length (mm)'; 'Baseline Diameter (mm)'; 'Target SF'}, ...
                      {primary_material.Name{1}; force_max; crank_len; crank_diam; target_sf}, ...
                      'VariableNames', {'Parameter', 'Value'});

writetable(results_table, fullfile(export_path, 'Design_Report.xlsx'));

fprintf('\nSUCCESS! Detailed reports and 2D overlay plots saved to:\n%s\n', export_path);
