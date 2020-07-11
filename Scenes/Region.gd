extends Node

const FEE_HAPPY_FACTOR = -10
const POTATO_HAPPY_FACTOR = 10
const POTATO_BUY_PRICE = 15
const POTATO_SELL_PRICE = 10
const POTATO_EXT_PRICE = 3 * POTATO_BUY_PRICE
const MAX_HAPPINESS = 100
const FEE_RATE = 0.2
const L = 1.0
const K = 1.0 # This probably needs to be moved closer to 0.1
const X0 = 0.0

const FARMER_SALARY = 100
const FEE_COLLECTOR_SALARY = 150
const WORKER_SALARY = 50

export var region_name = "[Name]"
export var region_id = -1
export var starting_population = 100
export var starting_happiness = 20

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

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set initial variables
	happiness = starting_happiness
	population = starting_population
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
	dM = 0
	
	# Update potato production
	dS = population # Start with one potato produced per person
	
	# Some way to have workers improve potatoes
	dS += imports - exports # Adjust by net flow
	
	if dS < 0:
		# Buy them at a super outrageous price
		dM += POTATO_EXT_PRICE * dS
	else:
		# Buy imports
		dM += POTATO_SELL_PRICE * exports - POTATO_BUY_PRICE * imports
	# Collect fees from citizens
	dM += population * numTaxCollectors * FEE_RATE
	# Pay salaries
	dM -= numPotatoFarmers * FARMER_SALARY + numTaxCollectors * FEE_COLLECTOR_SALARY + numWorkers * WORKER_SALARY
	
	# Calculate happiness
	dH = FEE_HAPPY_FACTOR * numTaxCollectors + POTATO_HAPPY_FACTOR * (dS / population - 1)

	
	# Apply a normalization to make it harder to succeed
	dH = L/(1+exp(-K * (X0 - dH)))
	
	happiness = min(MAX_HAPPINESS, happiness + dH)
	$RegionButton/HappinessLabel.set_happiness(round(happiness))
	$RegionButton/HappinessChangeLabel.set_happiness_change(dH)
	$RegionButton/PotatoesLabel.set_potatoes(dS)
	$RegionButton/MoneyLabel.set_money_change(dM)
	$RegionButton/ImportsLabel.set_imports(imports)
	$RegionButton/ExportsLabel.set_exports(exports)
	
	# Reconcile with national treasury (surplus/deficit)
	return dM


func _on_RegionButton_pressed():
	regionJobs.show()

func collect_fees():
	pass
