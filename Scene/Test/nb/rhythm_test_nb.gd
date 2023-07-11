extends Control

func _ready():
	$n_button_rhythm_element.button_amt = 4
	$n_button_rhythm_element2.button_amt = 4
	await Music.finished
	get_tree().change_scene_to_file("res://Scene/results.tscn")
