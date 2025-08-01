extends CollisionObject3D
class_name Interactable

signal interacted(body)

@export var prompt_message := "Interact"
@export var prompt_input := "interact"

func get_prompt() -> String:
	#var key_name := ""
	for event in InputMap.action_get_events(prompt_input):
		if event is InputEventKey:
			#key_name = event.as_text()
			break
	
	#return "%s\n[%s]" % [prompt_message, key_name]
	return "%s\n" % [prompt_message]

func interact(body: Node) -> void:
	interacted.emit(body)
	#print("%s interacted with %s" % [body.name, name])
