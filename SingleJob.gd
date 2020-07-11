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
	
#func _input(event):
#   # Mouse in viewport coordinates.
#   if event is InputEventMouseButton && event.pressed:
#	   print($Title.text, "Mouse Click/Unclick at: ", event.position, " factor ", event.factor, " index ", event.button_index, " p ", event.pressed)
#
#
#extends Node2D
#
#export var jobText = "no job text"
#
##export(String) var $Title.text = "no job text"
#
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	$Title.text = jobText
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#	#$Title.text = jobText
#
#tool
#extends Node
#export(String) var label_text setget update_label
#
#func update_label(new_text):
#  #if is_in_tree():
#	$Title.text = new_text



