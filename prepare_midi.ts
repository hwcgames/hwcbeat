import { Midi } from 'npm:@tonejs/midi@2.0.5'

// Read MIDI data from stdin
const from = [];
for await (const chunk of Deno.stdin.readable) {
	for (const byte of chunk) {
		from.push(byte)
	}
}

// Process to ToneJS JSON
const midi = new Midi(from);

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
console.log(JSON.stringify(song))

