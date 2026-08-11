#!/bin/bash
#SBATCH --job-name=prepare_singing
#SBATCH --output=/mnt/scratch/sc21rf/cadenza/logs/prepare_singing_%j.out
#SBATCH --error=/mnt/scratch/sc21rf/cadenza/logs/prepare_singing_%j.err
#SBATCH --time=04:00:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=6G

module load miniforge
module load cuda
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate cadenza

set -euo pipefail

cd /users/sc21rf/denoiser_train

python prepare_singing_data.py

echo "Data preparation complete"
