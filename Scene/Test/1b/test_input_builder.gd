extends Node

@export var subscription: MusicSubscription
@onready var in_rect: Control = %In

func _ready():
	Music.start.connect(subscribe)
	subscription.note.connect(note)

func subscribe():
	Music.subscriptions.push_back(subscription)

func note(note: Note):
	var cue = MusicCue.new();
	cue.action = "ui_accept"
	cue.pressed = true
	cue.when = note.time
	cue.early_fail = 0.3
	cue.early_tolerance = 0.25
	cue.late_tolerance = 0.25
	cue.missed.connect(missed)
	cue.passed.connect(passed)
	Music.pending_inputs.push_back(cue)
	await get_tree().create_timer(subscription.offset - 0.5).timeout
	in_rect.add_child(preload("Incoming.tscn").instantiate())
	pass

func missed(at: float):
	var pos = (at / 2) + 0.5
	var marker: Control = preload('FailedMarker.tscn').instantiate()
	marker.anchor_left = pos
	marker.anchor_right = pos
	in_rect.add_child(marker)
	pass
func passed(at: float):
	var pos = (at / 2) + 0.5
	var marker: Control = preload('PassedMarker.tscn').instantiate()
	marker.anchor_left = pos
	marker.anchor_right = pos
	in_rect.add_child(marker)
	pass
