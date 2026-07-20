#!/bin/bash
#SBATCH --job-name=cad2_en_base_nc
#SBATCH --output=/mnt/scratch/sc21rf/cadenza/logs/enhance_base_nc_%j.out
#SBATCH --error=/mnt/scratch/sc21rf/cadenza/logs/enhance_base_nc_%j.err
#SBATCH --time=01:00:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G

module load miniforge
module load cuda
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate cadenza

set -euo pipefail

DATA_ROOT="$SCRATCH/cadenza/train_data/cad2/task1"
EXP_DIR="$SCRATCH/cadenza/outputs/baseline_noncausal"

mkdir -p "$EXP_DIR"

cd $HOME/cadenza/clarity/clarity/recipes/cad2/task1/baseline

python enhance.py \
    path.root="$DATA_ROOT" \
    path.exp_folder="$EXP_DIR" \
    separator.causality=noncausal

echo "Enhance non-causal complete"
