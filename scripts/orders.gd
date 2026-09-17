extends Node

var orders = [
	{
		"id": "ORD-001",
		"items": {"HEADPHONES": 2, "PEN": 5, "KEYBOARD": 3},
		"status": "NEW"
	},
	{
		"id": "ORD-002",
		"items": {"PEN": 3, "MOUSE": 1, "BOTTLE": 1},
		"status": "NEW"
	},
	{
		"id": "ORD-003",
		"items": {"NOTEBOOK": 2, "HEADPHONES": 1},
		"status": "NEW"
	}
]

func get_order(index):
	if index < orders.size():
		return orders[index]
	return null

func validate_pick(active_order, item_id, picked_quantity, current_stock):
	if not active_order["items"].has(item_id):
		return "WRONG ITEM"
		
	if current_stock <= 0:
		return "OUT_OF_STOCK"
		
	if picked_quantity < active_order["items"][item_id]:
		return "CORRECT"
		
	return "WRONG ITEM"
