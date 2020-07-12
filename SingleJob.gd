extends Node2D

export(int) var width;
export(int) var height;

var salaryType

var parents = []
var lines = []
var children = []
# These are the children where we are their parent[0]
var layoutChildren = []

var employee = null

var locked = true

var isMultiJob = false

func get_num_workers():
	var numWorkers = 0
	if employee != null:
		numWorkers += 1
	return numWorkers
	

func unlock():
	locked = false
	$LockSprite.hide()

func can_add_employee():
	return !locked && employee == null
	
func add_employee(newEmployee):
	employee = newEmployee
	
func _ready():
	pass
	
func _process(delta):
	pass
	
func _draw():
	var position = $Background.rect_position
	var color = Color("310909")
	draw_circle(position + ($Background.rect_size / 2), 25, color)

func set_title(text):
	$Title.text = text
	var size = $Title.get_minimum_size()
	$Title.rect_size = size
	$Title.rect_position.x = floor(-(size.x / 2))
	
	var rect = $Background.get_rect()
	width = max(rect.size.x, $Title.get_rect().size.x)
	height = rect.size.y + rect.position.y

func under_mouse():
	var mouse = $Background.get_global_mouse_position()
	var rect = $Background.get_rect()
	rect.position.x += position.x
	rect.position.y += position.y
	var margin = 20
	rect.position.x -= margin
	rect.position.y -= margin
	rect.size.x += 2 * margin
	rect.size.y += 2 * margin
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



