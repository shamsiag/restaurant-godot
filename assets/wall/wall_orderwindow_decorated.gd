extends Node3D

var zone=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("delivery wall entered")
	%ActionPrompt.show()
	zone=true

func _on_area_3d_body_exited(body: Node3D) -> void:
	print("delivery wall Left")
	%ActionPrompt.hide()
	#%UIfatana.reset()
	zone=false

func _process(delta: float) -> void:
	if(Input.is_action_just_released("interaction") and zone):
		if(DataHandler.platJoueur):
			%UiDelivery.show()
			%ActionPrompt.hide()
		else:
			%UiDelivery.hide()
			%ActionPrompt.hide()
