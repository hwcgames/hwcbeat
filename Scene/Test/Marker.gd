extends ColorRect

func _ready():
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	tween.play()
	await tween.finished
	self.queue_free()
