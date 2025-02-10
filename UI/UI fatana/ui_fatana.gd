extends CanvasLayer

const listePlats=[
	"Misao",
	"Sandwich",
	"Gratin",
	"Soupe",
]

var index_fatana

func set_fatana_index(index: int):
	index_fatana=index

var platScene=preload("res://UI/UI fatana/Plat_card.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataHandler.platReady.connect(initPlatsCard)
	print("ui fatana ready")
	%MenuPrompt.hide()
	hide()
	for plat in DataHandler.listePlats:
		var instance=platScene.instantiate()
		instance.init(plat.nom)
		%HBoxContainer.add_child(instance)
		instance.selection.connect(platHandling)

func initPlatsCard() -> void:
	for ingredient in DataHandler.listePlats:
		var instance=platScene.instantiate()
		instance.init(ingredient)
		print("Plat: ",ingredient.nom)
		%HBoxContainer.add_child(instance)
		instance.selection.connect(platHandling)

# Called every frame. 'delta' is the elapsed time since the previous frame.


func toggle_menu() -> void:
	if(%MenuPrompt.visible):
		%MenuPrompt.hide()
		%ActionPrompt.show()
	else:
		%MenuPrompt.show()
		%ActionPrompt.hide()

func reset()-> void:
	%MenuPrompt.hide()
	%ActionPrompt.show()

func platHandling(plat: DataHandler.Plat)-> void:
	DataHandler.platsEnCours[index_fatana]=DataHandler.Plat.new(null,plat.nom,plat.ingredients,null,index_fatana,plat.recette)
	print("Plat selectionné: ",DataHandler.platsEnCours[index_fatana].nom,
	"Fatana:",DataHandler.platsEnCours[index_fatana].fatana)
	hide()
#func _on_button_button_up() -> void:
	#var nodes= %HBoxContainer.get_children()
	#var data=[]
	#for node in nodes:
	#	data.push_back(node.getQuantity())
	#print (data)
