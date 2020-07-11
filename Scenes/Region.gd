extends Node

const FEE_HAPPY_FACTOR = -1.2
const POTATO_HAPPY_FACTOR = 1.0
const POTATO_BUY_PRICE = 15
const POTATO_SELL_PRICE = 10
const L = 1.0
const K = 1.0 # This probably needs to be moved closer to 0.1
const X0 = 0.0

const FARMER_SALARY = 10
const FEE_COLLECTOR_SALARY = 20
const WORKER_SALARY = 5

export var region_name = "[Name]"
export var region_id = -1
export var starting_population = 100
export var starting_happiness = 20
export var starting_tax_effectiveness = 0.2

var happiness # Set initial happiness
var dH # Per-tick change in happiness
var fees
var dF # Per-tick change in fees collected
#var imports = 10
#var exports = 10
var dS # Per-tick calculation of surplus/deficit potatoes
var population
var dP # Per-tick calculation of change in population
var dM # Per-tick flow of money surplus/deficit

var regionJobs
var feeRate

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set initial variables
	happiness = starting_happiness
	population = starting_population
	feeRate = starting_tax_effectiveness
	# Update UI elements
	$RegionButton.set_text(region_name)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func tick(imports, exports):
	# Get region job data
	var numWorkers = regionJobs.get_num_workers()
	var numTaxCollectors = regionJobs.taxCollectors.employee.size()
	var numPotatoFarmers = regionJobs.potatoFarmers.employee.size()
	
	# Update potato production
	dS = population # Start with one potato produced per person
	
	# Some way to have workers improve potatoes
	dS += imports - exports # Adjust by net flow
	
	# Buy imports
	dM = POTATO_SELL_PRICE * exports - POTATO_BUY_PRICE * imports
	# Collect fees from citizens
	dM += feeRate * population
	# Pay salaries
	dM -= numPotatoFarmers * FARMER_SALARY + numTaxCollectors * FEE_COLLECTOR_SALARY + numWorkers * WORKER_SALARY
	
	# Calculate happiness
	dH = FEE_HAPPY_FACTOR * feeRate + POTATO_HAPPY_FACTOR * (dS / population)
	
	# Apply a normalization to make it harder to succeed
	dH = L/(1+exp(-K * (X0 - dH)))
	
	happiness = round(happiness + dH)
	$RegionButton/HappinessLabel.set_happiness(happiness)
	$RegionButton/PotatoesLabel.set_potatoes(dS)
	
	# Reconcile with national treasury (surplus/deficit)
	return dM


func _on_RegionButton_pressed():
	regionJobs.show()

func collect_fees():
	pass
