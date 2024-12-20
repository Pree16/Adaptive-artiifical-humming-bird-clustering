# Automatic Centroid Initialization in K-Means Using Artificial Hummingbird Algorithm
This repository contains an implementation of Automatic Centroid Initialization in K-Means Using Artificial Hummingbird Algorithm using MATLAB.

## Overview
This work enhances the k-means clustering algorithm by introducing an efficient and automatic method for centroid initialization based on the Artificial Hummingbird Algorithm (AHA). The primary goal is to improve clustering performance and convergence speed by avoiding poor initial centroids. (Link to paper: https://link.springer.com/article/10.1007/s00521-024-10764-4).

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
