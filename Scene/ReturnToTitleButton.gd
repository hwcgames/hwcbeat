extends Button

func _ready():
	pressed.connect(go)

func go():
	get_tree().change_scene_to_file("res://Scene/title.tscn")
