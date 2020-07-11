extends Node

const TAX_HAPPY_FACTOR = -1.2
const IMPORT_HAPPY_FACTOR = 1.0
const IMPORT_MONEY_FACTOR = -1.0

export var region_name = "[Name]"

var happiness = 80 # Set initial happiness
var taxes = 10
var imports = 20
var last_income = 0

var regionJobs

# Called when the node enters the scene tree for the first time.
func _ready():
	$RegionButton.set_text(region_name)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func tick():
	# Update the happiness
	happiness += TAX_HAPPY_FACTOR * taxes + IMPORT_HAPPY_FACTOR * imports
	$RegionButton/HappinessLabel.set_happiness(happiness)
	
	# Get region job data
	var numWorkers = regionJobs.get_num_workers()
	var numTaxCollectors = regionJobs.taxCollectors.employee.size()
	var numPotatoFarmers = regionJobs.potatoFarmers.employee.size()
	
	# Pass the income
	return IMPORT_MONEY_FACTOR * imports


func _on_RegionButton_pressed():
	regionJobs.show()
