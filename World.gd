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


func setup_region_jobs(region):
	var regionJobsTemplate = load("res://RegionJobs.tscn")
	var regionJob = regionJobsTemplate.instance()
	add_child(regionJob)
	regionJob.hide()
	region.regionJobs = regionJob
	regionJobs.append(regionJob)
	regionJob.setup(region.region_id)
	
	#$ResourcesPanel.move_child(self, get_child_count())
