extends Node2D

var action = 0
var money = 1000000
var payroll = 0
var income
export var alpha = 0.01 # Coefficient in front of exponent function
export var beta = 1.4 # Value of exponent

var regionJobs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for region in $Regions.get_children():
		setup_region_jobs(region)
	
	self.move_child($ResourcesPanel, get_child_count())
	self.move_child($MessagePanel, get_child_count())
	
	tick()
	

func tick():
	
	var numFailedRegions = 0
	for region in $Regions.get_children():
		if region.happiness < 1:
			numFailedRegions += 1
	if numFailedRegions >= 3:
		get_tree().change_scene("res://EndGame.tscn")
	
	
	# Start with a bunch of regional stuff (see region code)
	var potatoesPerDriver = 5
	var exportsByRegion = []
	var importsByRegion = []
	
	var inevitability = alpha * pow(action, beta)
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
		income += region.tick(importsByRegion[regionIndex], exportsByRegion[regionIndex], inevitability)
	money += income
	$ResourcesPanel/MarginContainer/HBoxContainer/MoneyLabel.set_money(money)
	action += 1
	$ResourcesPanel/MarginContainer/HBoxContainer/TurnLabel.set_tick(action)
	check_events()
	
	for regionIndex in regions.size():
		regions[regionIndex].update_gui(importsByRegion[regionIndex], exportsByRegion[regionIndex])
	


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
	
var event1 = false
var event2 = false
var event3 = false
var event4 = false
var nextEventTick = 0
func check_events():
	# Take the tick and see what we can do
	if action >= nextEventTick:
	
		var eventFired = false
	
		if !eventFired && !event1 && action >= 3:
			eventFired = true
			event1 = true
			show_message("The people grow weary of potatoes...")
			Global.POTATO_HAPPY_FACTOR -= 0.2
			
		if !eventFired && !event2 && action >= 10:
			eventFired = true
			event2 = true
			show_message("A clever comrade has submerged the potatoes in hot oil. Suddenly, spuds are all the rage again!")
			Global.POTATO_HAPPY_FACTOR += 0.2
			
		if !eventFired && !event3 && action >= 50:
			eventFired = true
			event3 = true
			show_message("Your people have realized that the new regime is little better than the old. Unrest grows...")
			beta += 0.2
			
		if !eventFired && !event4 && action >= 15:
			eventFired = true
			event4 = true
				
		
		if !eventFired && money <= 0:
			for region in $Regions.get_children():
				region.happiness -= 4
				region.happiness = max(0, region.happiness)
			eventFired = true
			show_message("Inablility of the Central happiness committee to pay salaries causes widespread sadness :`(")
	
		var unhappyRegions = []
		var regions = $Regions.get_children()
		for region in regions:
			if region.happiness < 5:
				unhappyRegions.append(region)
		
		if !eventFired && unhappyRegions.size() > 0:
			var region = unhappyRegions[randi()%unhappyRegions.size()]
			var neighbours
			match region.region_id:
				0:
					neighbours = [1, 2, 4]
				1:
					neighbours = [0, 2, 3]
				2:
					neighbours = [0, 1, 3, 4]
				3:
					neighbours = [1, 2, 4]
				4:
					neighbours = [0, 2, 3]
			var randNeighbourIndex = neighbours[randi()%neighbours.size()]
			var randNeighbour = regions[randNeighbourIndex]
			randNeighbour.happiness -= 10
			randNeighbour.happiness = max(0, randNeighbour.happiness)
			
			nextEventTick = action + 3 + (randi()%3)
			show_message("Riots in " + region.region_name + " spill over into " + randNeighbour.region_name + " :(")
			
		if eventFired:
			nextEventTick = action + 2 + (randi()%4)
			

func show_message(text):
	$MessagePanel/MarginContainer2/MessageLabel.show_message("Day " + str(action) + ": " + text)
