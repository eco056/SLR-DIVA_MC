# SLR-DIVA_MC
Code for the replication of the results in the article "Systematic sensitivity analysis of the full economic impacts of sea level rise"
This is a do file for Stata that, based on the DIVA data for the 13 regions of the article, recreates the analysis.
Starting from the initial dataset (downloaded through the code automatically),
the user can choose the type of Systematic Sencitivity analysis to be conducted. The idea is based on the fact that the GEMPACK software, 
usually used for simulations based on the GTAP model, does not have a built-in function for conducting a Monte Carlo SSA yet. 
Due to the nature of the data, to this point, the code allows for sampling based on the triangular distribution and we
test the use of piecewise linear probability distribution. When the number of simulations (chosen by the user) is completed,
the program collects the data (inputs and outputs) into a csv file that is then fed to Stata for further analysis.
The code assumes that GEMPACK, Stata and Matlab are installed in the computer and the user has full administrative 
rights on the C drive.

This work has been supported by the research project RISES-AM (contract FP7-ENV-2013- two-stage-603396)
