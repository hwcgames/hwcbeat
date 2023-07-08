import { Midi } from '@tonejs/midi'
import { readFile, writeFile } from 'fs/promises';

let infile = process.argv[2]
let outfile = process.argv[3];

(async () => {
	// Read MIDI data
	const midi_data = await readFile(infile)
	
	// Process to ToneJS JSON
	const midi = new Midi(midi_data);
	
	// Process to HWCBeat JSON
	// First, declare HWCBeat schema
	type HWCBeatSong = Array<HWCBeatCue>;
	type HWCBeatCue = {
		// Timestamp of the event in seconds.
		time: number,
		// Duration of the event in seconds.
		duration: number,
		// The name of the instrument as a string.
		channel: string,
		// The pitch of the instrument.
		pitch: number,
		// The volume of the instrument.
		volume: number,
	}
	// Then, combine tracks
	const song: HWCBeatSong = [];
	for (const track of midi.tracks) {
		const name = track.name || track.instrument.name;
		for (const note of track.notes) {
			song.push({
				time: note.time,
				duration: note.duration,
				channel: name,
				pitch: note.midi,
				volume: note.velocity,
			})
		}
	}
	// Then, sort by starting time.
	song.sort((a, b) => a.time - b.time)
	
	// Output JSON
	writeFile(outfile, JSON.stringify(song))
})();


