extends CanvasLayer

const listeIngredients=[
	"Tomate",
	"Pâtes",
	"Oignon",
	"Bouillon de soupe",
	"Porc",
	"Fromage",
	"Charcuterie",
	"Pain",
	"Riz",
	"Oeuf"
]

var ingredientScene=preload("res://UI/UI frigo/IngredientCard.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MenuPrompt.hide()
	%ActionPrompt.hide()
	hide()
	for ingredient in listeIngredients:
		var instance=ingredientScene.instantiate()
		instance.init(ingredient)
		%HBoxContainer.add_child(instance)



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


func _on_button_button_up() -> void:
	var nodes= %HBoxContainer.get_children()
	var data=[]
	for node in nodes:
		data=node.getQuantity()
		DataHandler.ingredientsJoueur.push_back(DataHandler.Ingredient.new(0,data[0],data[1]))
	DataHandler.printIngredientJoueur()
