extends Node2D

export(int) var width;
export(int) var height;

var parent = null
var children = []

var employee = []

var locked = true


func get_num_workers():
	return employee.size()


func unlock():
	locked = false
	$LockSprite.hide()
	
func can_add_employee():
	return !locked

func add_employee(newEmployee):
	employee.append(newEmployee)
	
func _ready():
	pass

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

