#!/usr/bin/env bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH -t 00:35:00
#SBATCH -J groupsize
#SBATCH -o log.%j
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-user=brush@princeton.edu

mkdir -p /scratch/network/brush/tmp/$SLURM_JOB_ID

echo '-------------------------------'
${SLURM_SUBMIT_DIR}
echo ${SLURM_SUBMIT_DIR}
echo Running on host $(hostname)
echo Time is $(date)
echo SLURM_NODES are $(echo ${SLURM_NODELIST})
echo '-------------------------------'
echo -e '\n\n'

EXEC=/usr/licensed/bin/matlab
OPTS=' -singleCompThread -nodisplay -nosplash'

export PROCS=${SLURM_CPUS_ON_NODE}

${EXEC}${OPTS} < effect_of_group_size.m

rm -rf /scratch/network/brush/tmp/$SLURM_JOB_ID