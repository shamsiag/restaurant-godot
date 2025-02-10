extends Node3D

@export var index = 0
var zone=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ValidationIngredients.hide()
	DataHandler.startTimer.connect(processTimer)

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("fatana 1 enteresd")
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
			if(DataHandler.platsEnCours[index]):
				if(DataHandler.platsEnCours[index].statut=="done"):
					%RecupPlat.setIndex(index)
					%RecupPlat.show()
					%RecupPlat.index=index
					%UIfatana.hide()
					%ValidationIngredients.hide()
				else:
					%ValidationIngredients.showIngredients()
					%ValidationIngredients.show()
					%ValidationIngredients.index=index
					%UIfatana.hide()
					if DataHandler.platsEnCours[index].ingredients:
						%ValidationIngredients.show()
						%ValidationIngredients.setText("Plat déja en cours de préparation")
			else:
				%UIfatana.toggle_menu()

func processTimer() -> void:
	%Timer.wait_time=DataHandler.getTimer(DataHandler.platsEnCours[index])
	%Timer.start()
	print("timer started, fatana:",index)

func _on_timer_timeout() -> void:
	DataHandler.platsEnCours[index].statut="done"
	print("timer finished, fatana:",index)
