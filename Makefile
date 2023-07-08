all: songs

songs: $(shell ls Song/*/*.midi | sed s/midi$$/json/)

%.json: %.midi
	cat $< | deno run prepare_midi.ts > $@ || rm $@