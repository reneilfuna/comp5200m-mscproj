#!/bin/bash
#SBATCH --job-name=cad2_eval_test
#SBATCH --output=/mnt/scratch/sc21rf/cadenza/logs/evaluate_test_%j.out
#SBATCH --error=/mnt/scratch/sc21rf/cadenza/logs/evaluate_test_%j.err
#SBATCH --time=00:10:00
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
EXP_DIR="$SCRATCH/cadenza/outputs/stage2_test"

cd $HOME/cadenza/clarity/clarity/recipes/cad2/task1/baseline

python evaluate.py \
    path.root="$DATA_ROOT" \
    path.exp_folder="$EXP_DIR" \
    evaluate.small_test=true

echo "Stage 2 evaluate test complete"
