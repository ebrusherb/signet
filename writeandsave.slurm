#!/usr/bin/env bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH -t 15:00:00
#SBATCH -J leakjob
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

${EXEC}${OPTS} < writeandsave_init.m

rm -rf /scratch/network/brush/tmp/$SLURM_JOB_ID