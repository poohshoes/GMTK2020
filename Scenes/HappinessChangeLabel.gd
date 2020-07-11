extends Label

func set_happiness_change(dH):
	if dH < 0:
		set_text("(Down {dH})".format({'dH' : dH}))
	elif dH > 0:
		set_text("(Up {dH})".format({'dH' : dH}))
	else:
		set_text("No Change")
