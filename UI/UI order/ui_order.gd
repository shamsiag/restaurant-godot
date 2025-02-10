extends CanvasLayer

var commandeScene=preload("res://UI/UI order/CommandeCard.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataHandler.commandesReady.connect(initCommandesCard)
	self.show


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initCommandesCard() -> void:
	var children = %vbox.get_children()
	for child in children:
		child.free()
		
	for commande in DataHandler.commandes:
		# Ne traiter que les commandes dont le statut est -1
		if commande.statut != 0:
			continue
			
		# Recherche du plat correspondant à la commande via l'id stocké dans commande.plat
		var plat: DataHandler.Plat = null
		for p in DataHandler.listePlats:
			if p.id == commande.plat:
				plat = p
				break
		if plat == null:
			print("Aucun plat trouvé pour la commande", commande.commande)
			continue
			
		plat.idCommande = commande.id
		var instance = commandeScene.instantiate()
		instance.init(plat)
		%vbox.add_child(instance)
