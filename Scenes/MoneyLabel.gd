extends Label

func set_money_change(dM):
	if dM < 0:
		set_text("(Down {dM})".format({'dM' : dM}))
	elif dM > 0:
		set_text("(Up {dM})".format({'dM' : dM}))
	else:
		set_text("No Change")
