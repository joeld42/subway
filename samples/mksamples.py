import os, sys

intervalPhrases = [
	"Unison",
	"Half Step",
	"Whole Step",
	"Minor Third",
	"Major Third",
	"Fourth",
	"Tri-tone",
	"Fifth",
	"Minor Sixth",
	"Major Sixth",
	"Minor Seventh",
	"Major Seventh",
	"Octave",

	# Note names
	"A.",
	"A. Sharp",
	"A. Flat",
	"B.",
	"B. Flat",
	"C.",
	"C. Sharp",
	"D.",
	"D. Sharp",
	"D. Flat",
	"E.",
	"E. Flat"
	"F.",
	"F. Sharp",
	"G.",
	"G. Sharp",
	"G. Flat"
]

for phrase in intervalPhrases:
	name = phrase.replace( " ", "_").lower()
	name = name.replace("-", "")
	name = name.replace(".", "")

	filename = name + ".aiff"
	
	exists = "(exists)"
	if (not os.path.exists(filename)):
		cmd = "say -o %s -v Samantha %s" % (filename, phrase)
		os.system(cmd)
		exists = ""

	print phrase, filename, exists