# Engineering Methodology and Failure Theories

## 1. Geometric Assumptions
The bicycle crank arm is modeled as a cantilever beam with a solid circular cross-section.
- Cross-Section Area (A): (π * d²) / 4
- Second Moment of Inertia (I): (π * d⁴) / 64
- Bending Moment (M): F * L
  - F: Pedaling Force
  - L: Crank Length
  - d: Diameter

## 2. Stress Analysis
- Normal Bending Stress (σᵦ): (M * c) / I = (32 * F * L) / (π * d³)
- Von Mises Equivalent Stress: For pure bending, σᵥₘ = σᵦ.
- Tresca Stress: Assumes failure when maximum shear stress exceeds yield shear.

## 3. Fatigue Failure Criteria
The tool implements the three standard criteria used in machine design to predict the Factor of Safety (n):

### Goodman (Standard)
Formula: (σₐ / Sₑ) + (σₘ / Sᵤₜ) = 1 / n
- σₐ: Alternating stress
- σₘ: Mean stress
- Sₑ: Endurance Limit
- Sᵤₜ: Ultimate Tensile Strength
*Best for most ductile materials under moderate loads.*

### Soderberg (Conservative)
Formula: (σₐ / Sₑ) + (σₘ / Sᵧ) = 1 / n
- Sᵧ: Yield Strength
*Used when any permanent deformation (yielding) is considered a failure.*

### Gerber (Optimistic)
Formula: (σₐ / Sₑ) + (σₘ / Sᵤₜ)² = 1 / n
*Often matches experimental data for specific ductile alloys but carries higher risk.*

## 4. Optimization Engine
The tool uses MATLAB's "fmincon" (Constrained Nonlinear Minimization).
- Objective Function: Minimize Weight (W)
- Weight Calculation: W = ρ * A * L (where ρ is density)
- Constraint: Calculated Goodman Factor of Safety (n) >= Target Factor of Safety
- Design Variable: Crank Diameter (d)

## 5. Material Data
All material properties (Sᵧ, Sᵤₜ, E, ρ, ν) are sourced from Appendix A of "Shigley's Mechanical Engineering Design," representing industry-standard baseline values for professional engineering analysis.
