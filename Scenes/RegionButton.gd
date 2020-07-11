extends Button

export var region_name = "Default"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#set_text(region_name)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _pressed():
	print(text)
