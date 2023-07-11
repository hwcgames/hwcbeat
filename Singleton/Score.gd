extends Node

var score = 0

signal gain(amt: int)
signal lose(amt: int)

func add_score(amt: int):
	if amt == 0:
		return
	score += amt
	if amt > 0:
		gain.emit(amt)
	if amt < 0:
		lose.emit(abs(amt))
