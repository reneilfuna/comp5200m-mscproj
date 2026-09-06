#!/bin/bash
#SBATCH --job-name=finetune_dns64_lr1e5
#SBATCH --output=/mnt/scratch/sc21rf/cadenza/logs/finetune_dns64_lr1e5%j.out
#SBATCH --error=/mnt/scratch/sc21rf/cadenza/logs/finetune_dns64_lr1e5%j.err
#SBATCH --time=24:00:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=6G

module load miniforge
module load cuda
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate denoiser

set -euo pipefail

cd /users/sc21rf/denoiser_train

python train.py \
    dset=singing \
    continue_pretrained=dns64 \
    restart=True \
    demucs.causal=1 \
    demucs.hidden=64 \
    demucs.resample=4 \
    batch_size=16 \
    segment=4 \
    stride=1 \
    epochs=50 \
    lr=1e-5 \
    ddp=0 \
    num_workers=4 \
    pesq=False

echo "Fine-tuning complete: lr=1e-5"
