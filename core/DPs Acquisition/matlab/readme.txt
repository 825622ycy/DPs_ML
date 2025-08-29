data_import.m：Import numerical data from text file as matrix
dispinfo.m：Function for formatted display of measurement information, presenting data in an aesthetically organized table format, mainly used for data inspection and debugging.
Getdata.m：Used for reading S-parameter measurement data from text files, performing data processing, and saving the results.
Getmyinfo.m：Read measurement-related metadata information from Excel files.
GetParaA.m：Used for calculating calibration parameter matrix A, which is employed to correct systematic errors in network analyzers.
GetRefEPs.m：Retrieves the complex permittivity（ε* = ε' - jε''）of reference materials from standard lookup tables and processes it into the format required for calibration.
main_Sparameter_mothed.m：Main function for calculating final dielectric properties using measured S-parameters, including selection of calibration materials, along with data display and storage capabilities.
ReadCaliRawdata.m：Intelligently reads calibration raw data to avoid redundant reading and processing of identical datasets.
ReferenceLiquids.m：Searches for the complex permittivity of reference materials, including calibration liquids and various biological tissues.
RetrieveEPs.m：Extracts the complex permittivity, electrical conductivity, and real-part permittivity of materials from calibrated S-parameter data.
s11_datanoise.m: This is used to generate the final training data for the model.
featurefunc.m: Data preprocessing and preparation, such as assigning labels to training datasets.
