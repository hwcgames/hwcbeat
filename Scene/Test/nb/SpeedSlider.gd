extends HSlider

func _ready():
	value_changed.connect(set_speed)

func set_speed(to: float):
	%SpeedLabel.text = "Speed: " + str(to/10) +"x - "
	Music.SoundPlayer.pitch_scale = to / 10
