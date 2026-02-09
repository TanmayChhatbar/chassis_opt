# WIP FSAE Chassis Optimization in MATLAB

This project aims to optimize the design of a Formula SAE (FSAE) chassis using MATLAB. The chassis is assumed to be a triangular space frame, with the objective of achieving an optimal balance between weight and stiffness. The optimization process considers multiple loading conditions and ensures that the resulting design meets or exceeds a specified minimum factor of safety.

![FSAE Chassis Optimization](./figures/basic_truss.png)

## Features

- Parametric modeling of a space frame chassis
- Evaluation of structural stiffness and mass
- Analysis under various loading scenarios (e.g., torsion, bending, point loads)
- Factor of safety constraints for all load cases
- Automated optimization to minimize weight while maintaining required stiffness and safety

## Getting Started

1. Clone the repository and open the MATLAB scripts.
2. Define your chassis geometry and loading conditions in the provided configuration files.
3. Define the no-go areas for the members.
4. Define the valid areas for the nodes.
5. Run the main optimization script to calculate the optimal chassis parameters.

## Requirements

- MATLAB with fmincon

## Usage

WIP 

## License

This project is licensed under the GPL v3 license.
