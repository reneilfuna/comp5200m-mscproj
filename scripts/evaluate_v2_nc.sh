#!/bin/bash
#SBATCH --job-name=cad2_eval_v2_nc
#SBATCH --output=/mnt/scratch/sc21rf/cadenza/logs/evaluate_v2_nc_%j.out
#SBATCH --error=/mnt/scratch/sc21rf/cadenza/logs/evaluate_v2_nc_%j.err
#SBATCH --time=48:00:00
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
OUT_DIR="$SCRATCH/cadenza/outputs/baseline_noncausal_mitigated"

mkdir -p "$OUT_DIR"

# Copy enhanced signals folder into mitigated output directory
# evaluate_mitigated.py reads from enhanced_signals/
ln -sfn "$EXP_DIR/enhanced_signals" "$OUT_DIR/enhanced_signals"

cd $HOME/cadenza/clarity/clarity/recipes/cad2/task1/baseline

python evaluate.py \
    path.root="$DATA_ROOT" \
    path.exp_folder="$OUT_DIR"

echo "Mitigated evaluate (non-causal) complete"
echo "Target comparison: original CTW 0.4223, mitigated CTW TBD"
