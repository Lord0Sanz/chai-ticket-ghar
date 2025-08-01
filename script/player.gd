extends CharacterBody3D

@onready var player: CharacterBody3D = $"."

@onready var cam: Camera3D = $cam
@onready var mobile: MeshInstance3D = $cam/mobile
@onready var cup: MeshInstance3D = $cam/cup

@export var move_speed: float = 5.0
@export var mouse_sensitivity: float = 0.002
@onready var ringtone: AudioStreamPlayer = $cam/mobile/Ringtone
@onready var pick_uptext: Label = $cam/mobile/pick_uptext

var is_mobile_open: bool = false
var player_paused: bool = false

var target_mobile_y: float = -1.2
var mobile_speed: float = 5.0

# Track previous state of wife's dialogue completion
var has_talked_to_wife_prev: bool = false

func _ready() -> void:
	mobile.position.y = -1.2
	_check_global_lock_state()
	ringtone.play()

func _process(delta: float) -> void:
	_check_global_lock_state()

	var pos = mobile.position
	pos.y = lerp(pos.y, target_mobile_y, delta * mobile_speed)
	mobile.position = pos

	# Auto-close mobile when wife dialogue finishes
	if not has_talked_to_wife_prev and Global.has_talked_to_wife:
		if is_mobile_open:
			is_mobile_open = false
			resume_player()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			target_mobile_y = -1.2

	has_talked_to_wife_prev = Global.has_talked_to_wife

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mobile"):
		is_mobile_open = !is_mobile_open
		if is_mobile_open:
			pause_player()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			target_mobile_y = -0.2

			if Global.has_talked_to_wife == false:
				ringtone.stop()
				pick_uptext.queue_free()
				DialogueManager.show_dialogue_balloon(load("res://dialogues/start_scene.dialogue"), "start")
			else:
				DialogueManager.show_dialogue_balloon(load("res://dialogues/mobile.dialogue"), "start")
		else:
			resume_player()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			target_mobile_y = -1.2

	if event is InputEventMouseMotion and not player_paused:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam.rotate_x(-event.relative.y * mouse_sensitivity)
		cam.rotation.x = clamp(cam.rotation.x, -deg_to_rad(80), deg_to_rad(80))

func _physics_process(_delta: float) -> void:
	if player_paused:
		return

	var input_dir: Vector2 = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.y = Input.get_axis("move_forward", "move_backward")

	var move_dir: Vector3 = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()

	velocity.x = move_dir.x * move_speed
	velocity.z = move_dir.z * move_speed
	velocity.y = 0.0

	move_and_slide()

func pause_player() -> void:
	player_paused = true
	velocity = Vector3.ZERO

func resume_player() -> void:
	player_paused = false

func _check_global_lock_state() -> void:
	if Global.player_locked:
		pause_player()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		resume_player()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
