This code has been created using MATLAB to predict the temperature of the milk under different circumstances.
One of the cases includes fluctuating ambient temperature, with the data provided in an Excel file for Michigan and Texas on August 1st, 2023.
The fitting sine function was then plugged into the ambient temperature variable.
A set of graphs is also attached here as a result of the solution to different cases. dsolve in MATLAB was used to solve the ODEs. 
fita is the file is used to plot the fitted sine functions.
fminsearch was used to get the right parameters of the sine function after iterations to find a function that fitted the data with minimal difference.
verification file was created to compare the hand solution to the solution of the MATLAB for the fluctuating case. 
