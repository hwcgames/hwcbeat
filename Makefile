all: songs

songs: $(shell ls Song/*/*.mid* | sed s/midi$$/json/ | sed s/mid$$/json/)

%.json: %.midi
	npm run prepare_midi "$<" "$@" || rm $@

.PRECIOUS: $(shell ls Song/*/*.mid* | sed s/mid$$/midi/)

%.midi: %.mid
	cp "$<" "$@"
	touch $@