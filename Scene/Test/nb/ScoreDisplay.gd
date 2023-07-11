extends Label

var tween: Tween

func _ready():
	Score.gain.connect(gain)
	Score.lose.connect(lose)

func gain(_amt):
	update()
	modulate = Color.GREEN
	if tween:
		tween.stop()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	tween.play()

func lose(_amt):
	update()
	modulate = Color.RED
	if tween:
		tween.stop()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	tween.play()

func update():
	text = 'Score: ' + str(Score.score)
