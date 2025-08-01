# Global.gd
extends Node

# Global Game State
var money: int = 0
var player_locked: bool = false
var player_called: bool = false
var player_holding_cup: bool = false
var has_talked_to_wife: bool = false
var has_talked_to_tc: bool = false
var has_talked_to_customer_1: bool = false
var has_talked_to_customer_2: bool = false
var has_talked_to_customer_3: bool = false
var customer_1_order_got: bool = false
var customer_2_order_got: bool = false
var customer_3_order_got: bool = false
var customer_1_order_complete: bool = false
var customer_2_order_complete: bool = false
var customer_3_order_complete: bool = false
var end_unlocked: bool = false
