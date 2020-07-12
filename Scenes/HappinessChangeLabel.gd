extends Label

func set_happiness_change(dH):
	if dH < 0:
		set_text("(dH Down {dH})".format({'dH' : dH}))
	elif dH > 0:
		set_text("(dH Up {dH})".format({'dH' : dH}))
	else:
		set_text("dH No Change")
