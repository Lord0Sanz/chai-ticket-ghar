extends Node3D

@onready var title: Label = $Control/pausemenu/VBoxContainer/TITLE
@onready var resume: Button = $Control/pausemenu/VBoxContainer/resume
@onready var controls: Button = $Control/pausemenu/VBoxContainer/controls
@onready var mainmenu: Button = $Control/pausemenu/VBoxContainer/mainmenu
@onready var controls_menu: GridContainer = $Control/pausemenu/VBoxContainer/controls_menu
@onready var back: Button = $Control/pausemenu/VBoxContainer/back
@onready var pausemenu: MarginContainer = $Control/pausemenu
@onready var player: CharacterBody3D = $Player
@onready var ui: AudioStreamPlayer = $ui
@onready var anim_fade: AnimationPlayer = $Control/fade/AnimationPlayer

func _ready() -> void:
	pausemenu.hide()
	controls_menu.hide()
	back.hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()

func _pause_game() -> void:
	get_tree().paused = true
	pausemenu.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _resume_game() -> void:
	get_tree().paused = false
	pausemenu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed() -> void:
	_resume_game()
	ui.play()

func _on_controls_pressed() -> void:
	controls_menu.show()
	back.show()
	resume.hide()
	controls.hide()
	mainmenu.hide()
	ui.play()

func _on_back_pressed() -> void:
	controls_menu.hide()
	back.hide()
	resume.show()
	controls.show()
	mainmenu.show()
	ui.play()

func _on_mainmenu_pressed() -> void:
	get_tree().paused = false
	ui.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	anim_fade.play("fade_in")
	var timer := get_tree().create_timer(2.0)
	await timer.timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
