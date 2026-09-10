extends Node2D


@onready var order_label = $UI/Order_Label
@onready var order_timer = $OrderTimer


# -------------------------
# CURRENT ORDER
# -------------------------

var current_order = 1

var headphones_required = 2
var pen_required = 5
var keyboard_required = 3


# -------------------------
# ITEMS PICKED
# -------------------------

var headphones_picked = 0
var pen_picked = 0
var keyboard_picked = 0


# -------------------------
# GAME VARIABLES
# -------------------------

var order_status = "PICKING"
var score = 0
var message = ""


# -------------------------
# GAME START
# -------------------------

func _ready():

	order_timer.start(60)

	order_timer.timeout.connect(_on_order_timer_timeout)

	update_order_text()


# -------------------------
# UPDATE TIMER ON SCREEN
# -------------------------

func _process(_delta):

	update_order_text()


# -------------------------
# KEYBOARD INPUT
# -------------------------

func _input(event):

	if event is InputEventKey and event.pressed and not event.echo:

		# PICKING STAGE
		if order_status == "PICKING":

			# 1 = Headphones
			if event.keycode == KEY_1:
				scan_item("Headphones")

			# 2 = Pen
			elif event.keycode == KEY_2:
				scan_item("Pen")

			# 3 = Keyboard
			elif event.keycode == KEY_3:
				scan_item("Keyboard")

			# Other warehouse products
			elif event.keycode == KEY_7:
				scan_item("Mouse")

			elif event.keycode == KEY_8:
				scan_item("Notebook")

			elif event.keycode == KEY_9:
				scan_item("Bottle")


		# 4 = PACK
		elif event.keycode == KEY_4 and order_status == "READY TO PACK":

			order_status = "PACKED"
			message = "ORDER PACKED"


		# 5 = DISPATCH
		elif event.keycode == KEY_5 and order_status == "PACKED":

			order_status = "COMPLETED"
			message = "ORDER COMPLETED"

			order_timer.stop()


		update_order_text()


# ==================================================
# SCAN ITEM
# ==================================================

func scan_item(item_name):

	# HEADPHONES
	if item_name == "Headphones":

		if headphones_picked < headphones_required:

			headphones_picked += 1
			score += 100

			message = "CORRECT ITEM: Headphones"

		else:

			message = "HEADPHONES ALREADY COMPLETE"


	# PEN
	elif item_name == "Pen":

		if pen_picked < pen_required:

			pen_picked += 1
			score += 100

			message = "CORRECT ITEM: Pen"

		else:

			message = "PEN ALREADY COMPLETE"


	# KEYBOARD
	elif item_name == "Keyboard":

		if keyboard_picked < keyboard_required:

			keyboard_picked += 1
			score += 100

			message = "CORRECT ITEM: Keyboard"

		else:

			message = "KEYBOARD ALREADY COMPLETE"


	# ANY OTHER PRODUCT = WRONG
	else:

		score -= 75

		message = "WRONG ITEM: " + item_name


	# -------------------------
	# CHECK IF ALL ITEMS PICKED
	# -------------------------

	if (
		headphones_picked == headphones_required
		and pen_picked == pen_required
		and keyboard_picked == keyboard_required
	):

		order_status = "READY TO PACK"
		message = "ALL ITEMS PICKED - READY TO PACK"


	update_order_text()


# ==================================================
# TIMER REACHES ZERO
# ==================================================

func _on_order_timer_timeout():

	if order_status != "COMPLETED":

		order_status = "LATE"
		message = "TIME UP!"

		score -= 150

		update_order_text()


# ==================================================
# UPDATE ORDER PANEL
# ==================================================

func update_order_text():

	var total_seconds = int(ceil(order_timer.time_left))

	var minutes = int(total_seconds / 60)
	var seconds = total_seconds % 60


	order_label.text = """ORDER #%03d

Headphones %d/%d
Pen %d/%d
Keyboard %d/%d

STATUS: %s
SCORE: %d
TIME: %02d:%02d

%s

CONTROLS

1 = Headphones
2 = Pen
3 = Keyboard

4 = PACK
5 = DISPATCH

7 = Mouse
8 = Notebook
9 = Bottle""" % [
		current_order,
		headphones_picked,
		headphones_required,
		pen_picked,
		pen_required,
		keyboard_picked,
		keyboard_required,
		order_status,
		score,
		minutes,
		seconds,
		message
	]
