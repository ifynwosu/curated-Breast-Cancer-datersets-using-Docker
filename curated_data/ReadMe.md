# Steps to follow

Download folders 1_* through 5_*.

Edit file paths if you want to save ouptut in a different folder.
        
        Examples
In the script "run_metadata.sh", edit the home directory volume "$HOME/Data" to your desired directory

In the script "parsefiles.R",  edit path of gseID.tsv on line 4 in  to your own specific path

In the script "createDir.R", edit the metadata_dir path to your desired path.

Run "echo $UID" to get your user id (Mine is 1005). Replace this in the "run_metadata.sh" scripts with yours. This helps with permissions issuses.
Run the bash scripts in each folder e.g "bash run_metadata.sh". Make sure to be within the folder where the script is located.

16Gb of ram for TCGA

Good and fast connection required
