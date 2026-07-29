function materials = get_material_properties()
    % GET_MATERIAL_PROPERTIES Returns a comprehensive table of material properties.
    % Data source: Shigley's Mechanical Engineering Design (Appendix A)
    % Compiled from Tables A-5, A-20, A-21, A-22, and A-24.

    % Format: {Name, Sy (MPa), Sut (MPa), Se (MPa), Density (kg/m3), E (GPa), nu}
    % Se (Endurance Limit) is estimated as 0.5*Sut for steels (max 700MPa),
    % 0.4*Sut for Al, and specific values from Table A-24 where available.

    data = {
        % --- ALUMINUM ALLOYS (Table A-24b, A-5) ---
        'Aluminum 2011-T6', 169, 324, 124, 2700, 71.7, 0.333;
        'Aluminum 2017-O', 70, 179, 90, 2700, 71.7, 0.333;
        'Aluminum 2024-O', 76, 186, 90, 2770, 72.4, 0.333;
        'Aluminum 2024-T3', 345, 482, 138, 2770, 72.4, 0.333;
        'Aluminum 2024-T4', 296, 446, 130, 2770, 72.4, 0.333;
        'Aluminum 3003-H12', 117, 131, 55, 2700, 71.7, 0.333;
        'Aluminum 3004-H38', 234, 276, 110, 2700, 71.7, 0.333;
        'Aluminum 5052-H36', 234, 269, 124, 2700, 71.7, 0.333;
        'Aluminum 6061-T6', 276, 310, 95, 2700, 71.7, 0.333;
        'Aluminum 7075-T6', 542, 593, 159, 2810, 71.7, 0.333;

        % --- CARBON STEELS (Table A-20, A-21) ---
        'Steel AISI 1006 HR', 170, 300, 150, 7850, 207.0, 0.292;
        'Steel AISI 1006 CD', 280, 330, 165, 7850, 207.0, 0.292;
        'Steel AISI 1018 HR', 220, 400, 200, 7850, 207.0, 0.292;
        'Steel AISI 1018 CD', 370, 440, 220, 7850, 207.0, 0.292;
        'Steel AISI 1030 HR', 260, 470, 235, 7850, 207.0, 0.292;
        'Steel AISI 1030 CD', 440, 520, 260, 7850, 207.0, 0.292;
        'Steel AISI 1040 HR', 290, 520, 260, 7850, 207.0, 0.292;
        'Steel AISI 1040 CD', 490, 590, 295, 7850, 207.0, 0.292;
        'Steel AISI 1045 HR', 310, 570, 285, 7850, 207.0, 0.292;
        'Steel AISI 1045 CD', 530, 630, 315, 7850, 207.0, 0.292;
        'Steel AISI 1050 HR', 340, 620, 310, 7850, 207.0, 0.292;
        'Steel AISI 1095 HR', 460, 830, 415, 7850, 207.0, 0.292;

        % --- ALLOY STEELS Q&T (Table A-21) ---
        'Steel AISI 4130 Q&T 400F', 1460, 1630, 700, 7850, 207.0, 0.292;
        'Steel AISI 4130 Q&T 1000F', 910, 1030, 515, 7850, 207.0, 0.292;
        'Steel AISI 4140 Q&T 400F', 1640, 1770, 700, 7850, 207.0, 0.292;
        'Steel AISI 4140 Q&T 1000F', 834, 951, 475, 7850, 207.0, 0.292;
        'Steel AISI 4340 Q&T 600F', 1590, 1720, 700, 7850, 207.0, 0.292;

        % --- STAINLESS STEELS (Table A-22, A-5) ---
        'Stainless Steel 303 Annealed', 241, 601, 250, 7850, 190.0, 0.305;
        'Stainless Steel 304 Annealed', 276, 568, 250, 7850, 190.0, 0.305;

        % --- TITANIUM ALLOYS (Table A-24c) ---
        'Titanium Ti-35A Annealed', 210, 275, 110, 4430, 114.0, 0.340;
        'Titanium Ti-50A Annealed', 310, 380, 152, 4430, 114.0, 0.340;
        'Titanium Ti-6Al-4V Annealed', 830, 900, 450, 4430, 114.0, 0.340;
        'Titanium Ti-13V-11Cr-3Al', 1207, 1276, 510, 4430, 114.0, 0.340;

        % --- OTHER METALS (Table A-5, A-24a) ---
        'Magnesium Alloy (Wrought)', 193, 276, 83, 1770, 44.8, 0.350;
        'Beryllium Copper', 965, 1200, 400, 8250, 124.0, 0.285;
        'Brass Cartridge 70%', 110, 300, 100, 8530, 106.0, 0.324;
        'Gray Cast Iron ASTM 20', 0, 152, 69, 7060, 100.0, 0.211; % Sy set to 0 for brittle
        'Gray Cast Iron ASTM 40', 0, 293, 127, 7060, 121.0, 0.211
    };

    % Convert to Table
    materials = cell2table(data, 'VariableNames', ...
        {'Name', 'YieldStrength', 'UltimateStrength', 'EnduranceLimit', 'Density', 'EModulus', 'PoissonRatio'});
end
