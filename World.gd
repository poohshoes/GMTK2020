extends Node2D

var action = 0
var money = 1000000
var payroll = 0
var income

var regionJobs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for region in $Regions.get_children():
		setup_region_jobs(region)
	
	self.move_child($ResourcesPanel, get_child_count())
	
	tick()
	
		
func tick():
	# Start with a bunch of regional stuff (see region code)
	var potatoesPerDriver = 5
	var exportsByRegion = []
	var importsByRegion = []
# warning-ignore:unused_variable
	for i in range(5):
		exportsByRegion.append(0)
		importsByRegion.append(0)
	for regionJobIndex in range(regionJobs.size()):
		var regionJob = regionJobs[regionJobIndex]
		for driverIndex in range(regionJob.potatoDrivers.size()):
			var potatoDrivers = regionJob.potatoDrivers[driverIndex]
			if potatoDrivers != null:
				var numDrivers = potatoDrivers.get_num_workers()
				exportsByRegion[regionJobIndex] += numDrivers * potatoesPerDriver
				importsByRegion[driverIndex] += numDrivers * potatoesPerDriver
	
	update_arrow(0, 1, $ArrowAB)
	update_arrow(0, 2, $ArrowAC)
	update_arrow(0, 4, $ArrowAE)
	update_arrow(1, 3, $ArrowBD)
	update_arrow(1, 2, $ArrowBC)
	update_arrow(2, 3, $ArrowCD)
	update_arrow(2, 4, $ArrowCE)
	update_arrow(3, 4, $ArrowDE)
	
	# Check game state
	# Introduce events for next action(s)
	
	income = 0 
	var regions = $Regions.get_children()
	for regionIndex in regions.size():
		var region = regions[regionIndex]
		income += region.tick(importsByRegion[regionIndex], exportsByRegion[regionIndex])
	money += income
	$ResourcesPanel/MarginContainer/HBoxContainer/MoneyLabel.set_money(money)
	action += 1
	$ResourcesPanel/MarginContainer/HBoxContainer/TurnLabel.set_tick(action)
	check_events()


func update_arrow(myRegion, otherRegion, arrow):
	var exportDrivers = regionJobs[myRegion].potatoDrivers[otherRegion].get_num_workers()
	var importDrivers = regionJobs[otherRegion].potatoDrivers[myRegion].get_num_workers()
	var diff = exportDrivers - importDrivers
	if diff == 0:
		arrow.hide()
	else:
		arrow.show()
		arrow.show()
		if diff > 0:
			arrow.rotation = arrow.startRotation
		else:
			arrow.rotation = arrow.startRotation + PI
		var potatoSprite = arrow.get_node("PotatoSprite")
		potatoSprite.rotation = -arrow.rotation + (PI / 4.0)
		var potatoScale = (abs(diff) + 1) / 5.0
		potatoSprite.scale = Vector2(potatoScale, potatoScale)

func setup_region_jobs(region):
	var regionJobsTemplate = load("res://RegionJobs.tscn")
	var regionJob = regionJobsTemplate.instance()
	add_child(regionJob)
	regionJob.hide()
	region.regionJobs = regionJob
	regionJobs.append(regionJob)
	regionJob.setup(region.region_id)

func check_game_state():
	pass # Check if game is over
	
func check_events():
	# Take the tick and see what we can do
	if action == 2:
		show_message("A wild event appeared! Wow! You're bananas")
	
	if action == 3:
		show_message("You're so screwed")

func show_message(text):
	$MessagePanel/MarginContainer2/MessageLabel.show_message(text)
