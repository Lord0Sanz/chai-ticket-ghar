extends Node3D

@onready var bill: TextureRect = $"../Control/bill"
@onready var amount: MarginContainer = $"../Control/amount"
@onready var money_balance: Label = $"../Control/amount/VBoxContainer/money"

@onready var masala: Label = $"../Control/bill/bill/VBoxContainer/GridContainer/masala"
@onready var masala_val: Label = $"../Control/bill/bill/VBoxContainer/GridContainer/masala_val"
@onready var ginger: Label = $"../Control/bill/bill/VBoxContainer/GridContainer/ginger"
@onready var ginger_val: Label = $"../Control/bill/bill/VBoxContainer/GridContainer/ginger_val"
@onready var elaichi: Label = $"../Control/bill/bill/VBoxContainer/GridContainer/elaichi"
@onready var elaichi_val: Label = $"../Control/bill/bill/VBoxContainer/GridContainer/elaichi_val"
@onready var coffee: Label = $"../Control/bill/bill/VBoxContainer/GridContainer/coffee"
@onready var coffee_val: Label = $"../Control/bill/bill/VBoxContainer/GridContainer/coffee_val"
@onready var bimal: StaticBody3D = $bimal

@onready var cup: MeshInstance3D = $"../Player/cam/cup"
@onready var masala_anim: AnimationPlayer = $"Masala Tea/masala_anim"
@onready var coffee_anim: AnimationPlayer = $Coffee/coffee_anim
@onready var ginger_anim: AnimationPlayer = $"Ginger Tea/ginger_anim"
@onready var elaichi_anim: AnimationPlayer = $"Elaichi Tea/elaichi_anim"
@onready var anim_manager: AnimationPlayer = $anim_manager
@onready var anim_fade: AnimationPlayer = $"../Control/fade/AnimationPlayer"
@onready var tc_mark: MeshInstance3D = $tc/mark
@onready var tea: AudioStreamPlayer = $"../Tea"

const PRICES = {
	"ginger": 40,
	"masala": 45,
	"coffee": 50,
	"elaichi": 40
}

var order_requirements := {
	"ginger": 0,
	"masala": 0,
	"coffee": 0,
	"elaichi": 0
}

var current_customer: int = 0
var cup_grabbed: bool = false
var exit_shown: bool = false

func _ready() -> void:
	money_balance.text = str(Global.money)
	cup.hide()

func _process(_delta: float) -> void:
	money_balance.text = str(Global.money)

	if Global.end_unlocked and not exit_shown:
		exit_shown = true
		anim_manager.play("show_exit")

func _on_tc_interacted(_body: Variant) -> void:
	if not Global.has_talked_to_tc:
		DialogueManager.show_dialogue_balloon(load("res://dialogues/TC1.dialogue"), "start")
		Global.has_talked_to_tc = true
		amount.show()
		clear_bill_items()
		tc_mark.hide()
		anim_manager.play("show_customers")
	else:
		DialogueManager.show_dialogue_balloon(load("res://dialogues/TC2.dialogue"), "start")

func _on_cup_interacted(_body: Variant) -> void:
	cup_grabbed = not cup_grabbed
	Global.player_holding_cup = cup_grabbed
	cup.visible = cup_grabbed

func try_fill_tea(kind: String, anim: AnimationPlayer) -> void:
	if not Global.player_holding_cup:
		return
	if order_requirements.get(kind, 0) <= 0:
		return

	anim.play("fill")
	tea.play()
	cup.hide()
	cup_grabbed = false
	Global.player_holding_cup = false

	order_requirements[kind] -= 1
	Global.money += PRICES[kind]
	_update_bill_ui(kind)

	if _order_completed():
		match current_customer:
			1: Global.customer_1_order_complete = true
			2: Global.customer_2_order_complete = true
			3: Global.customer_3_order_complete = true
		mark_order_complete(current_customer)

func _on_masala_tea_interacted(_body: Variant) -> void:
	try_fill_tea("masala", masala_anim)

func _on_coffee_interacted(_body: Variant) -> void:
	try_fill_tea("coffee", coffee_anim)

func _on_ginger_tea_interacted(_body: Variant) -> void:
	try_fill_tea("ginger", ginger_anim)

func _on_elaichi_tea_interacted(_body: Variant) -> void:
	try_fill_tea("elaichi", elaichi_anim)

# ——— CUSTOMER INTERACTIONS ——— #

func _on_customer_1_interacted(_body: Variant) -> void:
	if Global.customer_1_order_complete:
		return

	if Global.customer_1_order_got:
		bill.show()
		return

	if not can_start_new_order():
		DialogueManager.show_dialogue_balloon(load("res://dialogues/UI.dialogue"), "busy")
		bill.show()
		return

	DialogueManager.show_dialogue_balloon(load("res://dialogues/customer_1.dialogue"), "start")
	Global.customer_1_order_got = true
	order_requirements = {"ginger": 2, "masala": 1}
	current_customer = 1
	bill.show()
	clear_bill_items()
	for kind in order_requirements.keys():
		match kind:
			"ginger": set_bill_item(ginger, ginger_val, order_requirements[kind])
			"masala": set_bill_item(masala, masala_val, order_requirements[kind])

func _on_customer_2_interacted(_body: Variant) -> void:
	if not Global.customer_1_order_complete or Global.customer_2_order_complete:
		return

	if Global.customer_2_order_got:
		bill.show()
		return

	if not can_start_new_order():
		DialogueManager.show_dialogue_balloon(load("res://dialogues/UI.dialogue"), "busy")
		bill.show()
		return

	DialogueManager.show_dialogue_balloon(load("res://dialogues/customer_2.dialogue"), "start")
	Global.customer_2_order_got = true
	order_requirements = {"coffee": 3, "elaichi": 1}
	current_customer = 2
	bill.show()
	clear_bill_items()
	for kind in order_requirements.keys():
		match kind:
			"coffee": set_bill_item(coffee, coffee_val, order_requirements[kind])
			"elaichi": set_bill_item(elaichi, elaichi_val, order_requirements[kind])

func _on_customer_3_interacted(_body: Variant) -> void:
	if not Global.customer_2_order_complete or Global.customer_3_order_complete:
		return

	if Global.customer_3_order_got:
		bill.show()
		return

	if not can_start_new_order():
		DialogueManager.show_dialogue_balloon(load("res://dialogues/UI.dialogue"), "busy")
		bill.show()
		return

	DialogueManager.show_dialogue_balloon(load("res://dialogues/customer_3.dialogue"), "start")
	Global.customer_3_order_got = true
	order_requirements = {"ginger": 4, "masala": 2}
	current_customer = 3
	bill.show()
	clear_bill_items()
	for kind in order_requirements.keys():
		match kind:
			"ginger": set_bill_item(ginger, ginger_val, order_requirements[kind])
			"masala": set_bill_item(masala, masala_val, order_requirements[kind])

# ——— BILL + ORDER HELPERS ——— #

func can_start_new_order() -> bool:
	for value in order_requirements.values():
		if value > 0:
			return false
	return true

func _update_bill_ui(kind: String) -> void:
	var cnt = order_requirements[kind]
	match kind:
		"ginger": ginger_val.text = "%02d" % cnt
		"masala": masala_val.text = "%02d" % cnt
		"coffee": coffee_val.text = "%02d" % cnt
		"elaichi": elaichi_val.text = "%02d" % cnt

func _order_completed() -> bool:
	for cnt in order_requirements.values():
		if cnt > 0:
			return false
	return true

func clear_bill_items() -> void:
	masala.hide(); masala_val.hide()
	ginger.hide(); ginger_val.hide()
	elaichi.hide(); elaichi_val.hide()
	coffee.hide(); coffee_val.hide()

func set_bill_item(label: Label, value_label: Label, qty: int) -> void:
	label.show()
	value_label.show()
	value_label.text = "%02d" % qty

func mark_order_complete(customer_num: int) -> void:
	match customer_num:
		1: anim_manager.play("hide_customer_1")
		2: anim_manager.play("hide_customer_2")
		3: anim_manager.play("hide_customer_3")
	bill.hide()
	clear_bill_items()

func _on_exit_interacted(_body: Variant) -> void:
	anim_fade.play("fade_in")
	var timer := get_tree().create_timer(2.0)
	await timer.timeout
	get_tree().change_scene_to_file("res://scenes/ending.tscn")

func _on_bimal_interacted(_body: Variant) -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogues/bimal.dialogue"), "start")
	bimal.queue_free()
