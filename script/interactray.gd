extends RayCast3D

@onready var prompt: Label = $MarginContainer/text
@onready var unselect: TextureRect = $unselect
@onready var select: TextureRect = $select

func _physics_process(_delta: float) -> void:
	prompt.text = ""
	unselect.show()
	select.hide()
	if is_colliding():
		var collider = get_collider()
		if collider is Interactable:
			prompt.text = collider.get_prompt()
			unselect.hide()
			select.show()
			if Input.is_action_just_pressed("interact"):
				collider.interact(owner)
		#print("works")
		else:
			prompt.text = ""
			unselect.show()
			select.hide()
