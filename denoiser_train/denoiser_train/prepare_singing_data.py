import json
import sys
import torch
import torchaudio
import numpy as np
import soundfile as sf
from pathlib import Path

sys.path.insert(0, "/users/sc21rf/cadenza/clarity/clarity/recipes/cad2/task1/baseline")
from enhance_demucs import separate_sources, get_device, load_separation_model
from clarity.utils.flac_encoder import read_flac_signal

DATA_ROOT   = Path("/mnt/scratch/sc21rf/cadenza/train_data/cad2/task1")
OUTPUT_ROOT = Path("/users/sc21rf/denoiser_train/egs/singing")
SAMPLE_RATE = 44100
TARGET_SR   = 16000

device, _ = get_device(None)
sep_model  = load_separation_model("noncausal", device)
sep_model.eval()
print("Separator loaded")

with open(DATA_ROOT / "metadata" / "music.train.json") as f:
    music_train = json.load(f)

segments = list(music_train.items())
n        = len(segments)
print(f"Total segments: {n}")

# 80/10/10 split
n_train    = int(n * 0.8)
n_valid    = int(n * 0.1)
train_segs = segments[:n_train]
valid_segs = segments[n_train:n_train + n_valid]
test_segs  = segments[n_train + n_valid:]
splits     = {"tr": train_segs, "cv": valid_segs, "tt": test_segs}

print(f"Train: {len(train_segs)} | Valid: {len(valid_segs)} | Test: {len(test_segs)}")

for split in ["tr", "cv", "tt"]:
    (OUTPUT_ROOT / split / "noisy").mkdir(parents=True, exist_ok=True)
    (OUTPUT_ROOT / split / "clean").mkdir(parents=True, exist_ok=True)

for split_name, split_segs in splits.items():
    noisy_list = []
    clean_list = []

    print(f"\nProcessing {split_name}: {len(split_segs)} segments")

    for idx, (seg_id, seg) in enumerate(split_segs):
        try:
            track_path   = DATA_ROOT / "audio" / seg["path"]
            mixture_path = track_path / "mixture.flac"
            vocals_path  = track_path / "vocals.flac"

            if not mixture_path.exists() or not vocals_path.exists():
                print(f"  [{idx+1}] Skipping {seg_id} - files missing")
                continue

            mixture, sr = read_flac_signal(mixture_path)
            sr          = int(sr)
            start       = int(seg["start_time"] * sr)
            end         = int(seg["end_time"]   * sr)
            mixture_seg = mixture[start:end, :]

            est_sources = separate_sources(
                sep_model,
                mixture_seg.T,
                sr,
                segment=6.0,
                overlap=0.1,
                number_sources=2,
                device=device,
            )
            vocals_sep, _ = est_sources.squeeze(0).cpu().detach().numpy()
            noisy_mono = torch.from_numpy(
                vocals_sep[0].astype(np.float32)
            ).unsqueeze(0)

            vocals_clean, _ = read_flac_signal(vocals_path)
            clean_seg    = vocals_clean[start:end, 0]
            clean_mono   = torch.from_numpy(
                clean_seg.astype(np.float32)
            ).unsqueeze(0)

            noisy_16k = torchaudio.functional.resample(noisy_mono, sr, TARGET_SR)
            clean_16k = torchaudio.functional.resample(clean_mono, sr, TARGET_SR)

            noisy_path = OUTPUT_ROOT / split_name / "noisy" / f"{seg_id}.wav"
            clean_path = OUTPUT_ROOT / split_name / "clean" / f"{seg_id}.wav"

            sf.write(str(noisy_path), noisy_16k.squeeze(0).numpy(), TARGET_SR)
            sf.write(str(clean_path), clean_16k.squeeze(0).numpy(), TARGET_SR)

            n_samples = noisy_16k.shape[-1]
            noisy_list.append([str(noisy_path), n_samples])
            clean_list.append([str(clean_path), n_samples])

            if (idx + 1) % 100 == 0 or idx == 0:
                print(f"  [{idx+1}/{len(split_segs)}] {seg_id} - {n_samples} samples")

        except Exception as e:
            print(f"  [{idx+1}] Error on {seg_id}: {e}")
            continue

    with open(OUTPUT_ROOT / split_name / "noisy.json", "w") as f:
        json.dump(noisy_list, f, indent=2)
    with open(OUTPUT_ROOT / split_name / "clean.json", "w") as f:
        json.dump(clean_list, f, indent=2)

    print(f"  Written {len(noisy_list)} pairs to {split_name}")

print("\nData preparation complete.")
