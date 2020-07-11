extends Label

func set_exports(exports):
	set_text("Exports: {exports}".format({"exports": exports}))
