extends Node2D

var action = 0
var money = 1000000
var payroll = 0
var income

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
		
func tick():
	# Going to need to: 
		# Calculate total payroll
		# Update regional happiness
		# Calculate import-export regional stuff
		# Calculate taxes collected
	
	income = 0 
	for region in $Regions.get_children():
		income += region.tick()
	money += income
	$ResourcesPanel/MarginContainer/HBoxContainer/MoneyLabel.set_money(money)
	action += 1
	$ResourcesPanel/MarginContainer/HBoxContainer/TurnLabel.set_tick(action)
