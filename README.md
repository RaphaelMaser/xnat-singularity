# XNAT singularity
This repository contains the code to create and run a containerized version of a XNAT webserver using singularity. No root permissions are needed for the creation and execution of the container. It is therefore well suited for running in a multi-user environment like an HPC.

# Running XNAT
The repo contains the "run_xnat.sh" file which can be used to start the XNAT server. It also contains SLURM directives and can be run on an HPC using "sbatch run_xnat.sh". 

On the first start the script will create the singularity image. In every subsequent execution the script will only need to create a container from the image.

# Installing plugins
XNAT provides many useful plugins. The "XNAT OHIF viewer" for example provides an integration of the OHIF (Open Health Imaging Foundation) viewer which allows you to inspect patient data (CT or MRT scans) directly in XNAT.

Installing plugins is as easy as downloading the appropriate .jar file from the website and putting it in /xnat/plugins. After restart the plugins will be available.

# How the XNAT webserver in singularity works
Launching the script the first time will lead to the creation of a singularity image using the "xnat-singularity.def"-file. 

The image is based on debian bullseye and already includes an installed and configured version of tomcat 9.0. Tomcat is an open source webserver which is used to run XNAT. After the base image was downloaded from the docker hub, postgreSQL, a software for managing databases, will be installed and the required directories are created. Finally the XNAT.war file is downloaded to the tomcat/webapps directory (inside the image) so that tomcat can launch the application on startup.

After the image is created the script will attempt to create a container from it. Furthermore singularity will mount the folders mentioned in the section "folder structure" so that changes to the database and file uploads persist between restarts. Otherwise postgreSQL and XNAT would initialize a new database on every execution (since the image is read-only). During execution the permissions for postgreSQL are set and a new database is initialized if none is existing, otherwise the existing database is started. After postgreSQL was started tomcat will start the XNAT server and connect to the running postgreSQL instance.

# Folder structure
There are two important folders storing the XNAT data, the folders "xnat" and "postgres". 

The postgres folder contains two subfolders. The "config"-folder contains the configuration files for the database while the "data"-folder contains the SQL database itself (containing meta-data and configurations). 

The xnat folder contains the xnat configuration file used during container creation, a data folder containing the uploaded data (CT and MRT scans) and the plugins folder.

# Known bugs
Sometimes restarting the server leads to an error with PostgreSQL. This error can be seen in the output of the script, "[ - ]  postgresql" will be displayed instead of "[ + ]  postgresql". Stopping and restarting the script will usually work. Waiting a minute or two in between the restarts might also help.