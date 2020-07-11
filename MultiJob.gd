extends Node2D

#export var isUnderMouse = false

var parent = null
var children = []

var employee = null

func set_title(text):
	$Title.text = text

func under_mouse():
	var mouse = $Background.get_global_mouse_position()
	var rect = $Background.get_rect()
	rect.position.x += position.x
	rect.position.y += position.y
	return rect.has_point(mouse)


#func _on_Background_mouse_entered():
#	isUnderMouse = true
#
#func _on_Background_mouse_exited():
#	isUnderMouse = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var mouse = $Background.get_global_mouse_position()
#	var rect = $Background.get_rect()
#	rect.position.x += position.x
#	rect.position.y += position.y
#	$Background.color = Color.black
#	if rect.has_point(mouse):
#		$Background.color = Color.aliceblue



# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

