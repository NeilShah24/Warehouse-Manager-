extends Node

# Baseline product data. Notice "stock" is no longer hardcoded here.
const INITIAL_PRODUCTS = {
	"HEADPHONES": {"name": "Headphones", "shelf": "A01", "reorder_point": 2},
	"PEN":        {"name": "Pen",        "shelf": "B01", "reorder_point": 5},
	"KEYBOARD":   {"name": "Keyboard",   "shelf": "A02", "reorder_point": 2},
	"MOUSE":      {"name": "Mouse",      "shelf": "B02", "reorder_point": 2},
	"NOTEBOOK":   {"name": "Notebook",   "shelf": "A03", "reorder_point": 3},
	"BOTTLE":     {"name": "Bottle",     "shelf": "B03", "reorder_point": 3}
}

var products = {}
var backorders = {}

func _ready():
	# randomize() ensures you get a new set of random numbers every time the game runs
	randomize()
	reset_inventory()

# ==================================================
# 1. INVENTORY RESET & RANDOMIZATION
# ==================================================
func reset_inventory():
	products = INITIAL_PRODUCTS.duplicate(true)
	backorders.clear()
	
	# Loop through every product and assign a random starting stock (e.g., between 5 and 20)
	for item_id in products.keys():
		products[item_id]["stock"] = randi_range(5, 20)

# ==================================================
# 2. CORE STOCK LOGIC
# ==================================================
func get_stock(item_id):
	if products.has(item_id):
		return products[item_id]["stock"]
	return 0

func get_shelf(item_id):
	if products.has(item_id):
		return products[item_id]["shelf"]
	return "UNKNOWN"

func remove_stock(item_id, amount = 1):
	if products.has(item_id):
		if products[item_id]["stock"] >= amount:
			products[item_id]["stock"] -= amount
			return true
		else:
			var deficit = amount - products[item_id]["stock"]
			add_backorder(item_id, deficit)
	return false

# ==================================================
# 3. LOW-STOCK WARNINGS
# ==================================================
func is_low_stock(item_id):
	if products.has(item_id):
		return products[item_id]["stock"] <= products[item_id]["reorder_point"]
	return false

func get_low_stock_items():
	var low_stock_list = []
	for item_id in products.keys():
		if is_low_stock(item_id):
			low_stock_list.append(item_id)
	return low_stock_list

# ==================================================
# 4. BACKORDER HANDLING
# ==================================================
func add_backorder(item_id, amount):
	if backorders.has(item_id):
		backorders[item_id] += amount
	else:
		backorders[item_id] = amount
	print("BACKORDER LOGGED: %d units of %s" % [amount, item_id])

func get_backorders():
	return backorders

# ==================================================
# 5. DYNAMIC BOUNDARY TESTING
# ==================================================
func run_boundary_tests():
	print("--- STARTING INVENTORY BOUNDARY TESTS ---")
	reset_inventory()
	
	# Capture the random starting stock to test against
	var start_stock = get_stock("HEADPHONES")
	var reorder = products["HEADPHONES"]["reorder_point"]
	
	# Test 1: Standard Removal
	remove_stock("HEADPHONES", 1)
	assert(get_stock("HEADPHONES") == start_stock - 1, "FAIL: Stock should decrement by 1")
	
	# Test 2: Low-Stock Trigger
	var current = get_stock("HEADPHONES")
	remove_stock("HEADPHONES", current - reorder) # Force stock down exactly to the reorder point
	assert(is_low_stock("HEADPHONES") == true, "FAIL: Headphones should trigger low-stock warning")
	
	# Test 3: Negative Stock Prevention & Backorder Logging
	var success = remove_stock("HEADPHONES", 5) # Try to remove 5 when only at reorder limit
	var expected_deficit = 5 - reorder
	assert(success == false, "FAIL: Should reject removal exceeding stock")
	assert(get_stock("HEADPHONES") == reorder, "FAIL: Stock must not go negative")
	assert(backorders.has("HEADPHONES") and backorders["HEADPHONES"] == expected_deficit, "FAIL: Backorder deficit not logged correctly")
	
	# Test 4: System Reset
	reset_inventory()
	assert(get_stock("HEADPHONES") >= 5, "FAIL: Reset did not assign new random stock")
	assert(backorders.is_empty(), "FAIL: Reset did not clear backorders")
	
	print("--- ALL INVENTORY TESTS PASSED ---")
