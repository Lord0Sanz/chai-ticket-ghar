extends Node3D

@onready var play: Button = $MarginContainer/VBoxContainer/play
@onready var controls_bttn: Button = $MarginContainer/VBoxContainer/controls
@onready var controls: GridContainer = $MarginContainer/VBoxContainer/GridContainer
@onready var back: Button = $MarginContainer/VBoxContainer/back
@onready var animation_player: AnimationPlayer = $fade/AnimationPlayer
@onready var title: Label = $MarginContainer/VBoxContainer/title
@onready var ui: AudioStreamPlayer = $ui
@onready var quit: Button = $MarginContainer/VBoxContainer/quit

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	controls.hide()
	back.hide()

func _on_play_pressed() -> void:
	ui.play()
	animation_player.play("fade_in")
	controls.hide()
	back.hide()
	play.hide()
	controls_bttn.hide()
	title.hide()
	quit.hide()

	var timer := get_tree().create_timer(2.0)
	await timer.timeout

	get_tree().change_scene_to_file("res://scenes/developersnote.tscn")

func _on_controls_pressed() -> void:
	ui.play()
	controls.show()
	back.show()
	play.hide()
	controls_bttn.hide()
	quit.hide()

func _on_back_pressed() -> void:
	ui.play()
	controls.hide()
	back.hide()
	play.show()
	controls_bttn.show()
	quit.show()


func _on_quit_pressed() -> void:
	ui.play()
	animation_player.play("fade_in")
	var timer := get_tree().create_timer(2.0)
	await timer.timeout
	get_tree().quit()
