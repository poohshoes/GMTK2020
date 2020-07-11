extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rootJob
var singleJobTemplate
var multiJobTemplate
var viewport

var employeePool = []
var jobs = []

func employee_drag_end(employee):
	for job in jobs:
#		var background = job.get_node("Background")
		if !employee.hasJob && job.under_mouse() && job.employee == null:
			job.employee = employee
			employee.hasJob = true
	if !employee.hasJob:
		employee.return()
			
		

# Called when the node enters the scene tree for the first time.
func _ready():	
	viewport = get_viewport().size;
	singleJobTemplate = load("res://SingleJob.tscn")
	multiJobTemplate = load("res://MultiJob.tscn")
	
	rootJob = get_single_job("Regional Manager", null)
	
	var taxManager = get_single_job("Tax Bureau Overseer", rootJob)
	
	var taxCollector = get_multi_job("Tax Collectors", taxManager)
	
	layout(rootJob)


	var employeeTemplate = load("res://Employee.tscn")
	for i in range(5):
		var employee = employeeTemplate.instance()
		add_child(employee)
		employeePool.append(employee)
		employee.position.x = $EmployeePool.rect_position.x + (randi()%int($EmployeePool.rect_size.x))
		employee.position.y = $EmployeePool.rect_position.y + (randi()%int($EmployeePool.rect_size.y))
		employee.connect("drag_end", self, "employee_drag_end")



func layout(node):
	if node.parent == null:
		node.position.y = 0;
		node.position.x = viewport.x / 2
	else:
		node.position.y = node.parent.position.y + 100
		node.position.x = node.parent.position.x
		
	for child in node.children:
		layout(child)


func get_single_job(labelText, parent):
	var result = singleJobTemplate.instance()
	setup_job(labelText, parent, result)
	return result


func get_multi_job(labelText, parent):
	var result = multiJobTemplate.instance()
	setup_job(labelText, parent, result)
	return result


func setup_job(labelText, parent, child):
	add_child(child)
	jobs.append(child)
	child.set_title(labelText)
	child.parent = parent
	if (parent != null):
		parent.children.append(child)

#func get_single_job(labelText, parent):
#	var result = singleJobTemplate.instance()
#	add_child(result)
#	result.set_title(labelText)
#	result.parent = parent
#	if (parent != null):
#		parent.children.append(result)
#	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



#var dragTarget = null

## Todo(ian): Move this input code to the main scene so we don't call it for every RegionJobs instance.
#func _input(event):
#	# Mouse in viewport coordinates.
#	if event is InputEventMouseButton && event.button_index == 1:
#		if event.pressed:
#			start_drag(event.position)
#		else:
#			end_drag(event.position)
#
#
#func start_drag(mouse):
#	for employee in employeePool:
#		var sprite = employee.get_node("Sprite")
#		var pos = sprite.position + sprite.offset - ( (sprite.texture.get_size() / 2.0) if sprite.centered else Vector2() )
#		if Rect2(pos, sprite.texture.get_size()).has_point(mouse):
#			print("test:test")
#
#func end_drag(mouse):
#	pass
