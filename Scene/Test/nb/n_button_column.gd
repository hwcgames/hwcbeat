@tool
extends Control

@export var scored = false 
@export var action: String
@export var cue_template: MusicCue

@export var color: Color:
	set = set_color,
	get = get_color

var color_: Color

func set_color(color: Color):
	color_ = color
	%Icon.modulate = color
	for child in %Bar.get_children():
		child.modulate = color
	pass

func get_color():
	return color_
	pass

func note(note: Note):
	var start_cue = MusicCue.new()
	start_cue.early_tolerance = cue_template.early_tolerance
	start_cue.early_fail = cue_template.early_fail
	start_cue.late_tolerance = cue_template.late_tolerance
	start_cue.score_amt = cue_template.score_amt
	start_cue.pressed = true
	start_cue.action = action
	start_cue.when = note.time
	var end_cue: MusicCue
	if note.volume > 0.5:
		end_cue = MusicCue.new()
		end_cue.early_tolerance = cue_template.early_tolerance * 6.0
		end_cue.early_fail = 0
		end_cue.late_tolerance = cue_template.late_tolerance * 6.0
		end_cue.score_amt = cue_template.score_amt / 2.0
		end_cue.pressed = false
		end_cue.action = action
		end_cue.when = note.time + note.duration
	if scored:
		Music.pending_inputs.push_back(start_cue)
		if end_cue:
			Music.pending_inputs.push_back(end_cue)
	start_cue.passed.connect(passed)
	start_cue.missed.connect(missed)
	if end_cue:
		end_cue.passed.connect(passed)
		end_cue.missed.connect(missed)
	var incoming = preload("n_button_incoming.tscn").instantiate()
	incoming.scored = scored
	incoming.start_cue = start_cue
	incoming.end_cue = end_cue
	%Bar.add_child(incoming)
	pass

func passed(at: float, cue: MusicCue):
	print("Passed", ' ', "scored" if scored else "unscored")
	if scored:
		Score.add_score(cue.score_amt * (1 - abs(at)))
	%Icon.modulate = Color.GREEN
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(%Icon, "modulate", color_, 0.25)
	tween.play()
	pass

func missed(_at: float, cue: MusicCue):
	print("Missed", ' ', "scored" if scored else "unscored")
	if scored:
		Score.add_score(-0.1 * cue.score_amt)
	%Icon.modulate = Color.RED
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(%Icon, "modulate", color_, 0.25)
	tween.play()
	pass

func _ready():
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
		return
