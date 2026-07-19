This is a markdown file used to document the process of reproducing the
Cadenza baseline evaluation framework and the development of an ML pipeline
with the aim of improving lyric intelligibility in pop/rock music whilst 
maintaining good audio quality and balance. 

Logs:
1. SSH login for first time.
2. Set up working directories at: 
	"$HOME/cadenza/clarity",
	"$HOME/cadenza/envs",
	"$HOME/cadenza/scripts",
	"$SCRATCH/cadenza/data",
	"$SCRATCH/cadenza/outputs",
	"$SCRATCH/cadenza/logs",
3. load miniforge (everytime, in every shell), via:
	"module load miniforge"
4. Created environment.yaml for project, and confirmed clarity, torch, whisper and
   hydra are installed and importable. 
5. Whisper base.en model cached: 
	"python -c "import whisper; whisper.load_model'('base.en')"
	=> ~/.cache/whisper/base.en.pt 139M
6. Environment snapshot taken:
	"conda env export > $SCRATCH/cadenza/logs/env-snapshot-$(date +%Y%m%d).yaml"
	=> env-snapshot-20260719.yaml 8.4K
   Two snapshots currently exits, initial env build and 19 July build, size 
   difference confirms recipe dependencies. 
7. GPU env test on compute node. Aire GPU driver only supports up to CUDA 12.6,
   CUDA was built against 13.0 and thus unavailable on first test. 
   Fresh snapshot taken after fix. 
