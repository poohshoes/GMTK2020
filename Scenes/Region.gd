extends Node


const L = 2
const K = 0.02 # This probably needs to be moved closer to 0.1
const X0 = 1.0

# Used for diminishing happiness returns
const PHA = -51
const PHB = 0.02
const PHC = 1.0
const PHD = -1* PHA / PHC


export var region_name = "[Name]"
export var region_id = -1
export var starting_population = 100
export var starting_happiness = 20
export var fertility = 1.0

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

func tick(imports, exports, inevitability):
	# Get region job data
	var numWorkers = regionJobs.get_num_workers()
	var numPotatoFarmers = regionJobs.potatoFarmers.employee.size()
	var numTaxCollectors = regionJobs.taxCollectors.employee.size()
	var numBaristas = regionJobs.baristas.employee.size()
	var effectiveTaxCollectors = max(0, numTaxCollectors - numBaristas)
	var numLowSalary = regionJobs.get_num_workers_for_salary(Global.SALARY_LOW)
	var numMedSalary = regionJobs.get_num_workers_for_salary(Global.SALARY_MED)
	var numHighSalary = regionJobs.get_num_workers_for_salary(Global.SALARY_HIGH)
	
	# Calculate the inevitability of time as it ticks
	dM = 0
	
	# Update potato production
	dS = population # Start with one potato produced per person
	var farmerRate = min(1, numPotatoFarmers/20.0)
	var farmerMultiplier = 1 - pow(1 - farmerRate , 3) # ease out cubic
	dS *= 1 + (farmerMultiplier * 2)
	dS *= fertility
	dS = floor(dS)
	
	# Some way to have workers improve potatoes
	dS += imports - exports # Adjust by net flow
	
	if dS < 0:
		# Buy them at a super outrageous price
		dM += Global.POTATO_EXT_PRICE * dS
	else:
		# Buy imports
		dM += Global.POTATO_SELL_PRICE * exports - Global.POTATO_BUY_PRICE * imports
	# Collect fees from citizens
	dM += population * effectiveTaxCollectors * Global.FEE_RATE
	# Pay salaries
	dM -= numLowSalary * Global.SALARY_LOW + numMedSalary * Global.SALARY_MED + numHighSalary * Global.SALARY_HIGH
	
	# Calculate happiness
	dH = inevitability * (Global.FEE_HAPPY_FACTOR * effectiveTaxCollectors + potato_happiness())
	
	print("{region} potato happiness: {pH}".format({'region': region_name, 'pH': potato_happiness()}))
	print("{region} dH: {dH}".format({'region': region_name, 'dH': dH}))
#	print(Global.FEE_HAPPY_FACTOR * effectiveTaxCollectors)
	# print(dS/population)
	# Apply a normalization to make it harder to succeed
	dH = dH * (L/(1+exp(K * (dH - X0))))
	print("{region} Normalized dH: {dH}".format({'region': region_name, 'dH': dH}))
	#Note(ian): I didn't know how to tweak the formula to get this out.
#	dH = (0.5 - dH) * 10
	happiness = max(0, min(Global.MAX_HAPPINESS, happiness + dH))
	
	# Reconcile with national treasury (surplus/deficit)
	return dM
	
func update_gui(imports, exports):
	$RegionButton/LabelList/PopulationLabel.text = "Population: " + str(population)
	var fertilityText
	if fertility < 0.5:
		fertilityText = "Barren"
	elif fertility < 0.8:
		fertilityText = "Average"
	elif fertility < 1.5:
		fertilityText = "Fertile"
	else:
		fertilityText = "Cornucopia"
	$RegionButton/LabelList/FertilityLabel.text = "Fertility: " + fertilityText #str(int(fertility * 100))
	if happiness > 85:
		$RegionButton.set_happiness(1)
	elif happiness > 68:
		$RegionButton.set_happiness(2)
	elif happiness > 51:
		$RegionButton.set_happiness(3)
	elif happiness > 34:
		$RegionButton.set_happiness(4)
	elif happiness > 17:
		$RegionButton.set_happiness(5)
	else:
		$RegionButton.set_happiness(6)
	
	$RegionButton/LabelList/Happy/ArrowContainer/Arrow.flip_v = dH < 0
	var happyScale = min(max(0.25, abs(dH) / 10.0), 2)
	$RegionButton/LabelList/Happy/ArrowContainer/Arrow.rect_scale = Vector2(happyScale, happyScale)
	
	var spudScale = min(max(0.15, abs((dS/population))), 1.5)
	$RegionButton/LabelList/Spuds/Potato.rect_scale = Vector2(spudScale, spudScale)
	
	$RegionButton/LabelList/HappinessLabel.set_happiness(str(round(happiness)) + "/100")
	$RegionButton/LabelList/HappinessChangeLabel.set_happiness_change(dH)
	$RegionButton/LabelList/PotatoesLabel.set_potatoes(dS)
	$RegionButton/LabelList/MoneyLabel.set_money_change(dM)
	$RegionButton/LabelList/ImportsLabel.set_imports(imports)
	$RegionButton/LabelList/ExportsLabel.set_exports(exports)


func _on_RegionButton_pressed():
	regionJobs.show()

func collect_fees():
	pass

func potato_happiness(): # Can tweak the function this way easier.
	var x = (dS/population) - 1
	return Global.POTATO_HAPPY_FACTOR * ((PHA / (PHB * (x) + PHC)) + PHD)
	
