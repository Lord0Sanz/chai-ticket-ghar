extends Control

@onready var dialogue: Label = $title

var sections := [
	"""THANK YOU FOR PLAYING
Chai, Ticket, Ghar
A demo by PROJEKTSANSSTUDIOS

Made for GIC Jam 3
Theme: “Catch the Train”
Engine: Godot
Audio: Pixabay""",

	"""All game design, level assets, writing and concept
was by PROJEKTSANSSTUDIOS.
character assets by avatarsdk

Lead Dev: Shubhayu Kundu

This demo is a personal milestone 
my first time making a tycoon/simulator-style game.

All custom assets will be released for FREE on Sketchfab.
If you liked this, you can support me via my itch.io page.""",

	"""I had so many ideas and features I wanted to add,
but time constraints and university made it tough.

This game went through many changes and hits
but I still gave it everything I could.

Please leave a comment or review to let me know
if you'd like to see this grow into a full game.

With best regards,
PROJEKTSANSSTUDIOS""",

	"""All rights reserved © PROJEKTSANSSTUDIOS 2025"""
]

var typing_speed := 0.1
var pause_between_sections := 2.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	dialogue.text = ""
	await play_all_sections()

func play_all_sections() -> void:
	for section in sections:
		await typing_effect(section)
		await get_tree().create_timer(pause_between_sections).timeout
		dialogue.text = ""

	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func typing_effect(text: String) -> void:
	var i := 0
	await get_tree().create_timer(0.3).timeout
	while i < text.length():
		dialogue.text += text[i]
		i += 1
		await get_tree().create_timer(typing_speed).timeout
