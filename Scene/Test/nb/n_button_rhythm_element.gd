@tool
extends HBoxContainer

@export var colors: Array[Color]:
	set(colors):
		colors_ = colors
		apply_colors()
	get:
		return colors_

@export var button_amt: int:
	set(amt):
		while get_child_count() > amt:
			get_child(-1).free()
		while get_child_count() < amt:
			var new_child = preload('n_button_column.tscn').instantiate()
			add_child(new_child)
		apply_colors()
	get:
		return get_child_count()

@export var input_actions: Array[String]:
	set(actions):
		actions_ = actions
		apply_actions()
	get:
		return actions_

@export var scored: bool:
	set(scored):
		for child in get_children():
			child.scored = scored
		_scored = scored
	get:
		return _scored

var _scored: bool = false

@export var cue_template: MusicCue:
	set(cue):
		_cue_template = cue
		for child in get_children():
			child.cue_template = cue
	get:
		return _cue_template

var _cue_template: MusicCue

@export var cue_filter: String = "player"
@export var screen_length: float = 1.0

var colors_: Array[Color] = []
var actions_: Array[String] = []

func apply_colors():
	for child_index in range(get_child_count()):
		get_child(child_index).color = colors_[child_index]

func apply_actions():
	for index in range(get_child_count()):
		get_child(index).action = actions_[index]

func _ready():
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
		return
	scored = _scored
	Music.start.connect(start)

func start():
	var subscription = MusicSubscription.new()
	subscription.filter = cue_filter
	subscription.offset = screen_length
	subscription.note.connect(note)
	Music.subscriptions.push_back(subscription)

func note(note: Note):
	match note.pitch:
		0:
			print("Move camera to me!")
		_:
			get_child(note.pitch-1).note(note)
