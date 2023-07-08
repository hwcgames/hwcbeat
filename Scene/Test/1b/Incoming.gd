extends Control

@export var wait_time = 0.5

func _ready():
	var tween = get_tree().create_tween().bind_node(self)
	tween.set_parallel(true)
	tween.tween_property($Left, "anchor_left", 0.5, wait_time)
	tween.tween_property($Left, "anchor_right", 0.5, wait_time)
	tween.tween_property($Right, "anchor_left", 0.5, wait_time)
	tween.tween_property($Right, "anchor_right", 0.5, wait_time)
	tween.play()
	await tween.finished
	$Left.queue_free()
	$Right.queue_free()
	queue_free()
