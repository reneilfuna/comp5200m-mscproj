#!/bin/bash
#SBATCH --job-name=cad2_eval_base_nc
#SBATCH --output=/mnt/scratch/sc21rf/cadenza/logs/evaluate_base_nc_%j.out
#SBATCH --error=/mnt/scratch/sc21rf/cadenza/logs/evaluate_base_nc_%j.err
#SBATCH --time=07:00:00
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
EXP_DIR="$SCRATCH/cadenza/outputs/baseline_noncausal"

cd $HOME/cadenza/clarity/clarity/recipes/cad2/task1/baseline

python evaluate.py \
    path.root="$DATA_ROOT" \
    path.exp_folder="$EXP_DIR"

echo "Evaluate non-causal complete"
echo "Target: HAAQI 0.7841, CTW 0.3887, Overall 0.6737"
