#!/bin/bash
#SBATCH --job-name=demucs_ft_g0.0
#SBATCH --output=/mnt/scratch/sc21rf/cadenza/logs/demucs_ft_g0.0_%j.out
#SBATCH --error=/mnt/scratch/sc21rf/cadenza/logs/demucs_ft_g0.0_%j.err
#SBATCH --time=12:00:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=6G

module load miniforge
module load cuda
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate cadenza

set -euo pipefail

DATA_ROOT="/mnt/scratch/sc21rf/cadenza/train_data/cad2/task1"
EXP_DIR="/mnt/scratch/sc21rf/cadenza/outputs/demucs_finetuned_g0.0"

mkdir -p "$EXP_DIR"

cd /users/sc21rf/cadenza/clarity/clarity/recipes/cad2/task1/baseline

python enhance_demucs.py \
    path.root="$DATA_ROOT" \
    path.exp_folder="$EXP_DIR" \
    separator.causality=noncausal \
    demucs.gamma=0.0 \
    demucs.beta=0.5

echo "Fine-tuned enhance complete: gamma=0.0"
echo "Output: $EXP_DIR"
