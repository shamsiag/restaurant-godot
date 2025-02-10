extends CanvasLayer

var index

func setIndex(ind: int)->void:
	index=ind
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_2_button_up() -> void:
	self.hide()

func _on_button_button_up() -> void:
	print("récupération du plat")
	DataHandler.platJoueur=DataHandler.platsEnCours[index]
	print("plat à récuperer:",DataHandler.platJoueur.nom)
	print(DataHandler.platJoueur.nom)
	DataHandler.platsEnCours[index]=null
	self.hide()
