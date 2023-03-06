#!/bin/sh
#SBATCH -J XNAT
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH -c 7                # Cores assigned to each tasks
#SBATCH --time=0-24:00:00
#SBATCH -p batch

mkdir -p xnat/plugins
mkdir -p xnat-data/home/logs
mkdir -p xnat-data/archive 
mkdir -p xnat-data/build
mkdir -p xnat-data/cache
mkdir -p xnat-data/configs
mkdir -p postgres/data
mkdir -p postgres/run

singularity instance start -f -e --no-home --writable \
-B postgres/data:/var/lib/postgresql/data \
-B postgres/run:/var/lib/postgresql/run \
-B xnat/plugins:/data/xnat/home/plugins \
-B xnat-data/home/logs:/data/xnat/home/logs \
-B xnat-data/archive:/data/xnat/archive \
-B xnat-data/build:/data/xnat/build \
-B xnat-data/cache:/data/xnat/cache \
-B xnat-data/configs:/data/xnat/home/configs \
xnat-singularity.sif \
xnat