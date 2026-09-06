#!/bin/bash
#SBATCH --job-name=demucs_ft_eval_g0.4
#SBATCH --output=/mnt/scratch/sc21rf/cadenza/logs/demucs_ft_eval_g0.4_%j.out
#SBATCH --error=/mnt/scratch/sc21rf/cadenza/logs/demucs_ft_eval_g0.4_%j.err
#SBATCH --time=24:00:00
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
EXP_DIR="/mnt/scratch/sc21rf/cadenza/outputs/demucs_finetuned_g0.4"

cd /users/sc21rf/cadenza/clarity/clarity/recipes/cad2/task1/baseline

python evaluate.py \
    path.root="$DATA_ROOT" \
    path.exp_folder="$EXP_DIR" \
    separator.causality=noncausal

echo "Fine-tuned evaluate complete: gamma=0.4"
echo "Output: $EXP_DIR/scores.csv"
