extends Resource
class_name Note

@export var time: float
@export var duration: float
@export var channel: String
@export var pitch: int
@export var volume: float

func _init(from: Dictionary):
	time = float(from.get("time"))
	duration = float(from.get("duration"))
	channel = from.get("channel")
	pitch = int(from.get("pitch"))
	volume = float(from.get("volume"))
