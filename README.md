
# Automatic centroid initialization in k-means using artificial hummingbird algorithm

This repository contains an implementation of Automatic centroid initialization in k-means using artificial hummingbird algorithm using MATLAB.

## Instructions

1. **Run the Code**: 
   - Load `sample.mat` and run `main.m` in MATLAB.

2. **Dataset**: 
   - The code uses `sample.mat`, a synthetic dataset with 5 columns.

3. **Parameters**:
   - `MaxIt = 200`: Maximum iterations.
   - `nPop = 30`: Population size.

## Results
- Results are saved as Excel files:
  - `AHO_main.xlsx`: Main results including costs and intra/inter distances.
  - `AHO_convergence.xlsx`: Records best fitness over iterations.
  - `AHA_Cluster_CentreX.xlsx`: Final cluster centers.

## Requirements
- **MATLAB Version**: MATLAB R2020b or later is recommended.
- **Toolboxes Required**:
  - Statistics and Machine Learning Toolbox (for `pdist2` and normalization functions).
  - Excel file I/O support for saving results.
