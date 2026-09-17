extends Node

var orders = []
var current_order_index = 0
var total_orders_generated = 0

# The master list of item IDs to choose from
var available_items = ["HEADPHONES", "PEN", "KEYBOARD", "MOUSE", "NOTEBOOK", "BOTTLE"]

func _ready():
	# Randomize Godot's seed so orders are different every time you play
	randomize()
	reset_orders()

func reset_orders():
	orders.clear()
	current_order_index = 0
	total_orders_generated = 0
	
	# Generate 5 random orders for the queue
	for i in range(5):
		orders.append(create_random_order())

func create_random_order():
	total_orders_generated += 1
	
	var new_order = {
		"id": "ORD-%03d" % total_orders_generated,
		"items": {},
		"status": "NEW"
	}
	
	# Decide how many unique item types this order will ask for (e.g., 2 to 4)
	var num_types = randi_range(2, 4)
	
	# Duplicate and shuffle the item list to ensure we don't pick duplicates
	var shuffled = available_items.duplicate()
	shuffled.shuffle()
	
	for i in range(num_types):
		var item_id = shuffled[i]
		# Pick a random quantity required for this item (e.g., 1 to 4)
		var required_qty = randi_range(1, 4)
		new_order["items"][item_id] = required_qty
		
	return new_order

# ==========================================
# EXISTING LOGIC REMAINS THE SAME
# ==========================================

func get_current_order():
	if current_order_index < orders.size():
		return orders[current_order_index]
	return null

func advance_to_next_order():
	if current_order_index < orders.size():
		orders[current_order_index]["status"] = "COMPLETED"
	current_order_index += 1
	return get_current_order()

func has_more_orders():
	return current_order_index < orders.size()

func validate_pick(active_order, item_id, picked_quantity, current_stock):
	if active_order == null or not active_order["items"].has(item_id):
		return "WRONG_ITEM"

	if picked_quantity >= active_order["items"][item_id]:
		return "ALREADY_COMPLETE"

	if current_stock <= 0:
		return "OUT_OF_STOCK"

	return "CORRECT"
