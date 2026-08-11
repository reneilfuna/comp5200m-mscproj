#!/bin/bash
#SBATCH --job-name=demucs_enhance_b0.5
#SBATCH --output=/mnt/scratch/sc21rf/cadenza/logs/demucs_enhance_b0.5_%j.out
#SBATCH --error=/mnt/scratch/sc21rf/cadenza/logs/demucs_enhance_b0.5_%j.err
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

DATA_ROOT="$SCRATCH/cadenza/train_data/cad2/task1"
EXP_DIR="$SCRATCH/cadenza/outputs/demucs_noncausal_g0.0_b0.5"

mkdir -p "$EXP_DIR"

cd $HOME/cadenza/clarity/clarity/recipes/cad2/task1/baseline

python enhance_demucs.py \
    path.root="$DATA_ROOT" \
    path.exp_folder="$EXP_DIR" \
    separator.causality=noncausal \
    demucs.gamma=0.0 \
    demucs.beta=0.5

echo "DEMUCS enhance complete: gamma=0.0 beta=0.5"
echo "Output: $EXP_DIR"
