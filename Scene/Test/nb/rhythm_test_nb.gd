extends Control

func _ready():
	$n_button_rhythm_element.button_amt = 4
	$n_button_rhythm_element2.button_amt = 4
	await get_tree().physics_frame
	Music.play("polaris1")
