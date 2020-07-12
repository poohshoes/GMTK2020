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

func get_num_workers_for_salary(salaryType):
	var numWorkers = 0
	for job in jobs:
		if job.salaryType == salaryType:
			numWorkers += job.get_num_workers()
	return numWorkers
	

func get_num_workers():
	var numWorkers = 0
	for job in jobs:
		numWorkers += job.get_num_workers()
	return numWorkers

func check_lock(job):
	var parentsHappy = true
	for parent in job.parents:
		if parentsHappy:
			if parent.isMultiJob:
				var numWorkersAllowed = parent.get_num_workers() * parent.workersPerManager
				parentsHappy = job.get_num_workers() < numWorkersAllowed
			else:
				parentsHappy = parent.get_num_workers() == 1
	
	if parentsHappy && job.locked:
		job.unlock()
	elif !parentsHappy && !job.locked:
		job.lock()

func employee_drag_end(employee):
	for job in jobs:
#		var background = job.get_node("Background")
		if !employee.hasJob && job.under_mouse() && job.can_add_employee():
			job.add_employee(employee)
			employee.hasJob = true
			spawn_employee()
			for childJob in job.children:
				check_lock(childJob)
				#childJob.unlock()
			#if job.isMultiJob && job.parents.size() != 0 && job.parent.isMultiJob:
			check_lock(job)
				
			find_parent('World').tick()
	if !employee.hasJob:
		employee.return()

var taxCollectors
var potatoFarmers
var potatoDrivers = []
var baristas
func setup(regionId):	
	viewport = get_viewport().size;
	singleJobTemplate = load("res://SingleJob.tscn")
	multiJobTemplate = load("res://MultiJob.tscn")
	
	rootJob = get_single_job("Regional Manager", null, Global.SALARY_HIGH)
	rootJob.unlock()
	
	var assistant = get_single_job("Assistant to the Regional Manager", rootJob, Global.SALARY_LOW)
	var taxManager = get_multi_job("Party Membership Overseer", assistant, Global.SALARY_MED)
	taxManager.workersPerManager = 2
	taxManager.set_tooltip("Each Overseer can support up to 2 Fee Collectors")
	taxCollectors = get_multi_job("Membership Fee Collectors", taxManager, Global.SALARY_LOW)
	taxCollectors.set_tooltip("Increase income but decrease happiness")
	var baristaManager = get_single_job("Coffee Blend Master", assistant, Global.SALARY_MED)
	baristas = get_multi_job("Barista", baristaManager, Global.SALARY_LOW)
	baristas.set_tooltip("Make Fee Collectors less effective")
	
	var supervisor = get_single_job("Potato Production Supervisor", rootJob, Global.SALARY_MED)
	var potatoManager = get_single_job("Farm Safety Associate", supervisor, Global.SALARY_MED)
	var potatoManager2 = get_multi_job("Machinery Overseer", supervisor, Global.SALARY_MED)
	potatoManager2.workersPerManager = 3
	potatoManager2.set_tooltip("Each Overseer can support up to 3 Extraction Experts")
	potatoFarmers = get_multi_job("Potato Extraction Experts", potatoManager, Global.SALARY_LOW)
	potatoFarmers.set_tooltip("Increase Potato Production")
	extra_parent(potatoFarmers, potatoManager2)
	
	var shippingManager = get_single_job("Comptroller of Shipping", rootJob, Global.SALARY_HIGH)
	
	for i in range(5):
		potatoDrivers.append(null)
	match regionId:
		0:
			setup_shipper(1, shippingManager)
			setup_shipper(2, shippingManager)
			setup_shipper(4, shippingManager)
		1:
			setup_shipper(0, shippingManager)
			setup_shipper(2, shippingManager)
			setup_shipper(3, shippingManager)
		2:
			setup_shipper(0, shippingManager)
			setup_shipper(1, shippingManager)
			setup_shipper(3, shippingManager)
			setup_shipper(4, shippingManager)
		3:
			setup_shipper(1, shippingManager)
			setup_shipper(2, shippingManager)
			setup_shipper(4, shippingManager)
		4:
			setup_shipper(0, shippingManager)
			setup_shipper(2, shippingManager)
			setup_shipper(3, shippingManager)
	
	
	var depthMaxHeight = []
	var depthWidth = []
	get_layout_sizes(rootJob, depthMaxHeight, depthWidth, 0)
	var depthHeight = []
	var runningHeight = 120
	for i in range(depthMaxHeight.size()):
		depthHeight.append(runningHeight)
		runningHeight += depthMaxHeight[i] + 100
	#var maxWidth = depthWidth.max()
	var currentDepthWidth = []
	var graphWidth = viewport.x - $EmployeePool.get_rect().size.x
	for depth in range(depthWidth.size()):
		var unusedWidth = graphWidth - depthWidth[depth]
		currentDepthWidth.append(unusedWidth / 2)
	layout(rootJob, depthHeight, depthWidth, currentDepthWidth, 0)
	layout_lines(rootJob)


	employeeTemplate = load("res://Employee.tscn")
	for i in range(5):
		spawn_employee()

var employeeTemplate
func spawn_employee():
	var employee = employeeTemplate.instance()
	add_child(employee)
	employeePool.append(employee)
	employee.position.x = $EmployeePool.rect_position.x + (randi()%int($EmployeePool.rect_size.x))
	employee.position.y = $EmployeePool.rect_position.y + (randi()%int($EmployeePool.rect_size.y))
	employee.connect("drag_end", self, "employee_drag_end")

func extra_parent(child, parent):
	child.parents.append(parent)
	parent.children.append(child)

func setup_shipper(regionId, parent):
	var name = "NAME NOT FOUND"
	
	var regions = find_parent("World").get_node("Regions").get_children()
	var index = 0
	for region in regions:
		if index == regionId:
			name = region.region_name
		index += 1
	
	var shipperManager = get_single_job("Associate for " + name, parent, Global.SALARY_MED)
	potatoDrivers[regionId] = get_multi_job(name + " route Driver", shipperManager, Global.SALARY_LOW)
	potatoDrivers[regionId].set_tooltip("Transfer potatoes")

func get_layout_sizes(node, height, width, depth):
	if width.size() <= depth:
		width.append(0)
		height.append(0)
	width[depth] += node.width + 10
	height[depth] = max(node.height, height[depth])
	
	for child in node.layoutChildren:
		get_layout_sizes(child, height, width, depth + 1)

func layout(node, height, width, currentWidth, depth):
	var hMargin = 10
	currentWidth[depth] += hMargin
	node.position.x = floor(currentWidth[depth] + (node.width / 2))
	currentWidth[depth] += hMargin + node.width
	node.position.y = floor(height[depth])
	
	for child in node.layoutChildren:
		layout(child, height, width, currentWidth, depth + 1)
		
func layout_lines(node):
	for parent in node.parents:
		var parentPosition = parent.get_global_position()
		var myPosition = node.get_global_position()
		var lineOffset = parentPosition - myPosition
		lineOffset.y += parent.height
	
		var line = Line2D.new()
		line.set_name("line")
		node.add_child(line)
		node.move_child(line, 0)
		node.lines.append(line)
		line.add_point(Vector2(0, 0))
		line.add_point(lineOffset)
		line.width = 5
		line.default_color = Color("560b0b")
		line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
		
	for child in node.layoutChildren:
		layout_lines(child)
	
#	if node.parents.size() > 0:
#		var parentPosition = node.parents[0].get_global_position()
#		var myPosition = node.get_global_position()
#		var lineOffset = parentPosition - myPosition
#		lineOffset.y += node.parents[0].height
#		var line = node.get_node("Line2D")
#		line.points[1] = lineOffset



func layout2(node):
	if node.parent == null:
		node.position.y = 0;
		node.position.x = viewport.x / 2
	else:
		node.position.y = node.parent.position.y + 100
		node.position.x = node.parent.position.x

	for child in node.layoutChildren:
		layout2(child)


func get_single_job(labelText, parent, salaryType):
	var result = singleJobTemplate.instance()
	setup_job(labelText, parent, result, salaryType)
	return result

func get_multi_job(labelText, parent, salaryType):
	var result = multiJobTemplate.instance()
	setup_job(labelText, parent, result, salaryType)
	return result


func setup_job(labelText, parent, child, salaryType):
	child.salaryType = salaryType
	add_child(child)
	jobs.append(child)
	child.set_title(labelText)
	if parent != null:
		child.parents.append(parent)
		parent.children.append(child)
		parent.layoutChildren.append(child)

func _on_TextureButton_pressed():
	hide()
	
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

