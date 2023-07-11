extends LineEdit

func _ready():
	update(text)
	text_changed.connect(update)
	%GoButton.pressed.connect(go)

func update(text: String):
	var results = %MatchingLevels
	for child in results.get_children():
		child.queue_free()
	var dir = DirAccess.open("res://Song")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.contains(text) or text == "":
				var label = Label.new()
				label.text = file_name
				results.add_child(label)
			file_name = dir.get_next()
	if results.get_child_count() == 0:
		var label = Label.new()
		label.modulate = Color.RED
		label.text = "thats not a level nerd"
		%GoButton.disabled = true
	else:
		%GoButton.disabled = false

func go():
	get_tree().change_scene_to_file("res://Scene/Test/nb/rhythm_test_nb.tscn")
	Music.call_deferred("play", text)
