import os, sys
import subprocess

# Want interval names?
samples = [
"unison.aiff",
"half_step.aiff",
"whole_step.aiff",
"minor_third.aiff",
"major_third.aiff",
"fourth.aiff",
"tritone.aiff",
"fifth.aiff",
"minor_sixth.aiff",
"major_sixth.aiff",
"minor_seventh.aiff",
"major_seventh.aiff",
"octave.aiff"
]


# Want note durations?
# for note in ['a', 'b', 'c', 'd', 'e', 'f', 'g']:
# 	samples.append( note + ".aiff" )
# 	samples.append( note + "_sharp.aiff" )
# 	samples.append( note + "_flat.aiff" )

# Prints sample durations in a form that can be copy-pasted
# into a swift array for playback
for sample in samples:
	if os.path.exists(sample):
		
		info = subprocess.check_output(["afinfo", sample ])
		for line in info.split("\n"):
			if line.startswith("estimated duration:"):
				dur = line[19:-4]
				print '  "%s" : %s,' % (sample, dur)
