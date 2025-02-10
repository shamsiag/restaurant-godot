extends CanvasLayer

var index
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_button_up() -> void:
	DataHandler.checkIngredientsRecette(DataHandler.platsEnCours[index])
	print(DataHandler.platsEnCours[index].ingredients)
	print("ingredients mis dans plat")
	self.hide()

func showIngredients() -> void:
	%RichTextLabel.text="Vous allez ajouter ces ingredients à la marmite:"
	if DataHandler.checkIngredientsJoueur():
		for ingredient in DataHandler.ingredientsJoueur:
			%RichTextLabel.text=%RichTextLabel.text+"   "+ingredient.nom+" x"+str(ingredient.quantite)+" "
		DataHandler.printIngredientJoueur()
	else:
		%RichTextLabel.text="Prenez des ingrédients dans le frigo d'abord"

func _on_button_2_button_up() -> void:
	self.hide()

func setText(data: String) ->void:
	%RichTextLabel.text=data
