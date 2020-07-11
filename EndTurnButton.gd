extends Button


func _pressed():
	find_parent('World').tick()
	
