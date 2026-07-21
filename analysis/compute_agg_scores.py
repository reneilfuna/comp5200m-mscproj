import pandas as pd

variants = [
    (
	"NonCausal",
	"/mnt/scratch/sc21rf/cadenza/outputs/baseline_noncausal/scores.csv",
	{"haaqi": 0.7841, "ctw": 0.3887, "overall": 0.6737},
    ),
    (
	"Causal",
	"/mnt/scratch/sc21rf/cadenza/outputs/baseline_causal/scores.csv",
	{"haaqi": 0.7755, "ctw": 0.3744, "overall": 0.6549},
    ),
]

rows = []

for variant, path, targets in variants:
    df = pd.read_csv(path)

    haaqi   = df["haaqi_avg"].mean()
    ctw     = df["whisper_be"].mean()
    overall = df["score"].mean()

    rows.append({
	"variant": variant,
	"n_pairs": len(df),
	"haaqi_reproduced": round(haaqi, 4),
	"haaqi_target": targets["haaqi"],
	"haaqi_delta": round(haaqi - targets["haaqi"], 4),
	"ctw_reproduced": round(ctw, 4),
	"ctw_target": targets["ctw"],
	"ctw_delta": round(ctw - targets["ctw"], 4),
	"overall_reproduced": round(overall, 4),
	"overall_target": targets["overall"],
	"overall delta": round(overall - targets["overall"], 4),
})

summary = pd.DataFrame(rows)

output = "/users/sc21rf/cadenza/analysis/baseline_reproduction.csv"
summary.to_csv(output, index=False)

print(summary.to_string(index=False))
print(f"\nSummary written to {output}")

