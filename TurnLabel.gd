extends Label

var ref_turn = 0

func set_tick(tick):
	set_text("Day {day}".format({"day": tick}))
