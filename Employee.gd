extends Node2D

signal drag_end

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var originalMousePosition
var lastMousePosition
var dragging = false

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
var hasJob = false

func return():
	position = originalMousePosition

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		var mousePosition = get_viewport().get_mouse_position()
		var mouseChange = mousePosition - lastMousePosition
		position += mouseChange
		lastMousePosition = mousePosition


func _on_CenterContainer_gui_input(event):
	#Todo(ian): don't do this if the employee isn't in the pool anymore
	if event is InputEventMouseButton && event.button_index == 1:
		if event.pressed && !hasJob:
			dragging = true;
			originalMousePosition = get_viewport().get_mouse_position()
			lastMousePosition = originalMousePosition
		elif dragging:
			dragging = false;
			emit_signal("drag_end", self)
