extends Button

export var region_name = "Default"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$LabelList/Happy/Arrow.rect_scale = Vector2(0.5, 0.5)
	#set_text(region_name)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _pressed():
	print(text)

var happy1 = preload("res://images/face1.png")
var happy2 = preload("res://images/face2.png")
var happy3 = preload("res://images/face3.png")
var happy4 = preload("res://images/face4.png")
var happy5 = preload("res://images/face5.png")
var happy6 = preload("res://images/face6.png")

func set_happiness(happyness):
	match happyness:
		1:
			$LabelList/Happy/Face.set_texture(happy1)
		2:
			$LabelList/Happy/Face.set_texture(happy2)
		3:
			$LabelList/Happy/Face.set_texture(happy3)
		4:
			$LabelList/Happy/Face.set_texture(happy4)
		5:
			$LabelList/Happy/Face.set_texture(happy5)
		6:
			$LabelList/Happy/Face.set_texture(happy6)
