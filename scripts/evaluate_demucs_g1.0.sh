#!/bin/bash
#SBATCH --job-name=demucs_eval_g1.0
#SBATCH --output=/mnt/scratch/sc21rf/cadenza/logs/demucs_eval_g1.0_%j.out
#SBATCH --error=/mnt/scratch/sc21rf/cadenza/logs/demucs_eval_g1.0_%j.err
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

DATA_ROOT="$SCRATCH/cadenza/train_data/cad2/task1"
EXP_DIR="$SCRATCH/cadenza/outputs/demucs_noncausal_g1.0"

cd $HOME/cadenza/clarity/clarity/recipes/cad2/task1/baseline

python evaluate.py \
    path.root="$DATA_ROOT" \
    path.exp_folder="$EXP_DIR" \
    separator.causality=noncausal

echo "DEMUCS evaluate complete: gamma=1.0"
echo "Output: $EXP_DIR/scores.csv"
