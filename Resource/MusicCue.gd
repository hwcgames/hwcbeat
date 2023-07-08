extends Resource
class_name MusicCue

@export var action: String
@export var when: float
@export var early_tolerance: float
@export var late_tolerance: float
@export var early_fail: float
@export var pressed: bool

signal missed(by: float)
signal passed(by: float)

func _init():
	pass
