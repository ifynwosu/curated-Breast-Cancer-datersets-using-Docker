# the "functions" and "scripts" folder as well as the sample List file
# should be placed in the current working directory before running the commands below.

#With update to readr, GEOquery stops working.
#This is a temporary workaround
#Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 1000)
#readr::local_edition(1)

#getting things ready
source("scripts/LoadLibraries.R")
source("scripts/createDir.R")

#getting required functions
source("functions/getFromGEO.R")
source("functions/removeUnusefulCols.R")
source("functions/removeColsWithOnlyOneValue.R")
source("functions/removeColsWithAllUniqueValue.R")
source("functions/summariseVariables.R")
source("functions/writeOutput.R")

#parse Files
source("scripts/parseFiles.R")