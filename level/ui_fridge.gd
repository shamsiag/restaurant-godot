extends CanvasLayer


var ingredientScene=preload("res://UI/UI frigo/IngredientCard.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataHandler.ingredientsReady.connect(initIngredientsCard)
	%MenuPrompt.hide()
	%ActionPrompt.hide()
	

func initIngredientsCard() ->void:
	#for ingredient in DataHandler.ingredientsFrigo:
			#print("UI fridge, ID:", ingredient.id, "Nom:", ingredient.nom)
	hide()
	print(DataHandler.ingredientsFrigo)
	for ingredient in DataHandler.ingredientsFrigo:
		var instance=ingredientScene.instantiate()
		instance.init(ingredient)
		#print("Ingredients frigo: ",ingredient.nom)
		%HBoxContainer.add_child(instance)


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


func _on_button_button_up() -> void:
	DataHandler.ingredientsJoueur=[]
	var nodes= %HBoxContainer.get_children()
	print(nodes)
	var data=[]
	for node in nodes:
		data=node.getQuantity()
		if data[2]>0:
			DataHandler.ingredientsJoueur.push_back(DataHandler.Ingredient.new(data[0],data[1],data[2]))
	DataHandler.printIngredientJoueur()
	self.hide()
