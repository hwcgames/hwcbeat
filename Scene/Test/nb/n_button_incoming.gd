extends TextureRect

@export var start_cue: MusicCue
@export var end_cue: MusicCue
@onready var start_time = Music.SoundPlayer.get_playback_position()

var pixels_per_second: float
var scored = true
var start_cue_passed = false

func _ready():
	var column_length_seconds = start_cue.when - start_time;
	var column_length_pixels = float(get_parent().size.y)
	var cue_length = (end_cue.when - start_cue.when) if end_cue else 0
	pixels_per_second = column_length_pixels / column_length_seconds
	%Tail.offset_bottom = cue_length * pixels_per_second
	start_cue.passed.connect(hit_start_cue)

func _physics_process(delta):
	var time = Music.SoundPlayer.get_playback_position()
	var progress = (time - start_time) / (start_cue.when - start_time)
	if progress <= 1:
		anchor_top = 1 - progress
		anchor_bottom = 1 - progress
	elif time <= (end_cue.when if end_cue else 0):
		if not (scored or start_cue_passed):
			start_cue.passed.emit(0, start_cue)
			start_cue_passed = true
		anchor_top = 0
		anchor_bottom = 0
		var cue_length = (end_cue.when - time) if end_cue else 0
		%Tail.offset_bottom = cue_length * pixels_per_second
	else:
		if end_cue and not scored:
			end_cue.passed.emit(0, end_cue)
		queue_free()

func hit_start_cue(_at: float, _cue: MusicCue):
	%Tail.modulate = Color.WHITE
	if not end_cue:
		queue_free()
