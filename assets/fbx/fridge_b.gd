extends Node3D

var zone=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Entered")
	%UIfridge.show()
	zone=true

func _on_area_3d_body_exited(body: Node3D) -> void:
	print("Left")
	%UIfridge.hide()
	%UIfridge.reset()
	zone=false

func _process(delta: float) -> void:
	if(Input.is_action_just_released("interaction") and zone):
		%UIfridge.toggle_menu()
