all: songs

songs: $(shell ls Song/*/*.midi | sed s/midi$$/json/)

%.json: %.midi
	npm run prepare_midi "$<" "$@" || rm $@