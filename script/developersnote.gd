extends Control

@onready var dialogue: Label = $title

var full_text := """DEVELOPER'S NOTE

This is my first attempt at making a simulator-style game.
I wanted to avoid the usual endless runner and try something different.

The gameplay is short and simple, but if this demo gets support,
I'll absolutely work on expanding it into a full experience.

Balancing university and this project was tough n time was limited,
but I gave it everything I could.

Please forgive the minimal scope. My focus was to capture the
Indian railway vibe with a PSX-inspired aesthetic.

~ PROJEKTSANSSTUDIOS"""

var typing_speed := 0.1

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	dialogue.text = ""
	await typing_effect(full_text)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func typing_effect(text: String) -> void:
	await get_tree().create_timer(0.5).timeout
	for i in text.length():
		dialogue.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
