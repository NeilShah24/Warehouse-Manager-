extends Node

var products = {
	"HEADPHONES": {"name": "Headphones", "stock": 10, "shelf": "A01", "reorder_point": 2},
	"PEN": {"name": "Pen", "stock": 25, "shelf": "B01", "reorder_point": 5},
	"KEYBOARD": {"name": "Keyboard", "stock": 8, "shelf": "A02", "reorder_point": 2},
	"MOUSE": {"name": "Mouse", "stock": 7, "shelf": "B02", "reorder_point": 2},
	"NOTEBOOK": {"name": "Notebook", "stock": 15, "shelf": "A03", "reorder_point": 3},
	"BOTTLE": {"name": "Bottle", "stock": 12, "shelf": "B03", "reorder_point": 3}
}

func get_stock(item_id):
	if products.has(item_id):
		return products[item_id]["stock"]
	return 0

func remove_stock(item_id, amount = 1):
	if products.has(item_id) and products[item_id]["stock"] >= amount:
		products[item_id]["stock"] -= amount
		return true
	return false
