extends Node3D

@export var index = 0
var zone=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("fatana 1 entered")
	%UIfatana.set_fatana_index(index)
	%UIfatana.show()
	
	zone=true

func _on_area_3d_body_exited(body: Node3D) -> void:
	print("fatana 1 Left")
	%UIfatana.hide()
	%UIfatana.reset()
	zone=false

func _process(delta: float) -> void:
	if(Input.is_action_just_released("interaction") and zone):
		%UIfatana.toggle_menu()
