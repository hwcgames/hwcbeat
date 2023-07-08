extends Node

@onready var SoundPlayer: AudioStreamPlayer = AudioStreamPlayer.new();

#class WantsSignal extends Resource:
#	@export var offset: float
#	@export var filter: String
#
#	signal note(Note)
#
#	func _init():
#		pass

var pending_inputs: Array[MusicCue] = []
var subscriptions: Array[MusicSubscription] = []
var timer: float = 0
var notes: Array[Note] = []
var prevent_fail = 0

signal paused
signal resumed
signal start

func _ready():
	add_child(SoundPlayer)

func stop(transition_time=0.5):
	if SoundPlayer.playing:
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property(SoundPlayer, "volume_db", -50, transition_time/2)
		tween.play()
		await tween.finished
		SoundPlayer.stop()
	pending_inputs = []
	subscriptions = []
	timer = 0
	notes = []

func pause():
	get_tree().paused = true
	SoundPlayer.stream_paused = true
	self.set_physics_process(false)
	paused.emit()

func resume():
	get_tree().paused = false
	SoundPlayer.stream_paused = false
	self.set_physics_process(true)
	resumed.emit()

func play(song: String, transition_time=0.5):
	stop(transition_time)
	SoundPlayer.volume_db
	var audio: AudioStream = load("res://Song/"+song+"/"+song+".ogg")
	var json: String = FileAccess.get_file_as_string("res://Song/"+song+"/"+song+".json")
	var json_notes = JSON.parse_string(json)
	for note in json_notes:
		notes.push_back(Note.new(note))
	SoundPlayer.stream = audio
	SoundPlayer.play()
	start.emit()

func ffw(to: float):
	prevent_fail += 1
	if to < SoundPlayer.get_playback_position():
		SoundPlayer.pitch_scale = -2.0
	else:
		SoundPlayer.pitch_scale = 5.0
	while SoundPlayer.get_playback_position() < to:
		await get_tree().physics_frame
	SoundPlayer.pitch_scale = 1.0
	SoundPlayer.seek(to)
	prevent_fail -= 1

func _physics_process(_delta):
	var new_time_truth: float = SoundPlayer.get_playback_position()
	for subscription in subscriptions:
		var old_time: float = timer + subscription.offset
		var new_time: float = new_time_truth + subscription.offset
		var matching_notes: Array[Note] = []
		# Notes will always be sorted, so we can search only until we find a note that's too late.
		for note in notes:
			if note.time <= new_time:
				if note.time > old_time and \
				subscription.filter in note.channel:
					matching_notes.push_back(note)
			else:
				break
		for note in matching_notes:
			subscription.note.emit(note)
	var missed = []
	for input in pending_inputs:
		# Inputs that the player acts upon are handled in _input.
		# This is only for missed inputs.
		if new_time_truth > input.when + input.late_tolerance:
			if prevent_fail > 0:
				input.passed.emit(0)
			else:
				input.missed.emit(1)
			missed.push_back(input)
	for input in missed:
		pending_inputs.remove_at(pending_inputs.find(input))
	timer = new_time_truth

func _input(event):
	if SoundPlayer.stream_paused:
		return
	var time: float = SoundPlayer.get_playback_position()
	var actions = []
	for action in InputMap.get_actions():
		if event.is_action(action):
			actions.push_back(action)
	if actions == []:
		return
	var pressed = false
	if "pressed" in event:
		pressed = event.pressed
	else:
		return
	var relevant: Array[MusicCue] = pending_inputs.filter(func(input: MusicCue):
		return input.when - max(input.early_fail, input.early_tolerance) < time and \
		input.when + input.late_tolerance >= time and \
		input.action in actions and \
		input.pressed == pressed
	)
	
	relevant.sort_custom(func(a, b): abs(a.when - time) < abs(b.when - time))
	
	for input in relevant:
		if time < input.when - input.early_tolerance:
			if prevent_fail > 0:
				input.passed.emit(0)
			else:
				input.missed.emit((time - input.when) / input.early_tolerance)
		else:
			if time < input.when:
				input.passed.emit((time - input.when) / input.early_tolerance)
			else:
				input.passed.emit((time - input.when) / input.late_tolerance)
		pending_inputs.remove_at(pending_inputs.find(input))
		break;
