# Bicycle Crank Arm Design Optimization & Fatigue Analysis Tool (MATLAB)

![MATLAB](https://img.shields.io/badge/Language-MATLAB-orange.svg) 
![Engineering](https://img.shields.io/badge/Domain-Mechanical%20Design-blue.svg)
![Optimization](https://img.shields.io/badge/Focus-Optimization%20%26%20Fatigue-green.svg)

A professional engineering application developed in MATLAB to predict the fatigue life and optimize the weight of a bicycle crank arm. This tool integrates multi-material selection, nonlinear optimization algorithms, and exhaustive sensitivity analysis to provide a complete design-space visualization.

## 🌟 Key Features
- **38+ Material Database**: Comprehensive library of standard alloys (Al, Steel, Ti, Mg) sourced from *Shigley’s Mechanical Engineering Design*.
- **Multi-Constraint Optimization**: Uses the `fmincon` algorithm to find the minimum component mass while satisfying specific safety factor targets.
- **Fatigue Math Engine**: Implements industry-standard **Goodman**, **Soderberg**, and **Gerber** failure criteria.
- **Interaction Overlay**: Allows direct comparison of different materials on the same sensitivity curves.
- **Global Design Map**: Generates 7 high-resolution engineering reports for trade-off analysis.

---

## 📊 The 7 Professional Design Charts
Every analysis run generates a unique, timestamped data pack containing:
1.  **Safety Sizing Tool**: Identifies the critical diameter boundary for the chosen material.
2.  **Load Sensitivity**: Visualizes robustness against varying rider weights.
3.  **Optimization Map**: Quantifies sizing requirements across the force spectrum.
4.  **Weight Penalty Map**: Shows the exact mass-to-safety trade-off.
5.  **Leverage Sensitivity**: Analyzes how crank arm length erodes the Factor of Safety.
6.  **Load Capacity Envelope**: Defines the definitive "Rider Weight Limit" for the geometry.
7.  **Material Efficiency Rank**: Ranks materials by **Specific Strength** (Strength-to-Weight ratio).

---

## 🚀 How to Run
1. **Clone the repository** or download the project files.
2. Open **MATLAB** and set the current folder to the project directory.
3. Type `crank_arm_main` in the Command Window and press **Enter**.
4. **Follow the Prompts**:
   - Define your primary design parameters (Material, Load, Dimensions).
   - Enter comparison materials to overlay on your charts.
   - Choose which variables to optimize or keep fixed.
5. **View Results**: All charts and Excel reports are saved to your Desktop in the `Crank_arm_results` folder.

---

## 🛠️ Project Structure
| File | Description |
| :--- | :--- |
| `crank_arm_main.m` | Primary interactive script and user workflow engine. |
| `get_material_properties.m` | Database containing 38+ engineering material constants. |
| `calculate_stress.m` | Core physics engine for Bending and Von Mises stress. |
| `calculate_safety_factors.m` | Implementation of Fatigue failure criteria logic. |
| `optimize_crank.m` | Nonlinear minimization engine for weight reduction. |
| `generate_plots.m` | Advanced plotting module for multi-material overlays. |
| `METHODOLOGY.md` | Detailed technical documentation of formulas and theory. |

---

## 📐 Technical Theory
The crank arm is modeled as a cantilever beam under cyclic bending. 
- **Peak Bending Stress**: σᵦ = (32 * F * L) / (π * d³)
- **Reliability Target**: n ≥ nₜₐᵣ_ᵍₑₜ (where n is the Factor of Safety)
- **Weight Efficiency**: W = ρ * A * L

For a deep dive into the engineering math, see [METHODOLOGY.md](./METHODOLOGY.md).

---

## 📧 Contact
Created by [Your Name] – feel free to reach out for design inquiries or collaboration!
