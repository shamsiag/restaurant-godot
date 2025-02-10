extends Control

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func init(plat: DataHandler.Plat) -> void:
	var tempText=""
	%CommandeName.text=plat.nom+" ,id:"+str(plat.idCommande)
	
	for ingredient in plat.recette:
		tempText= tempText + "\n" + ingredient.nom + " x"+str(ingredient.quantite)
	%CommandeIngredients.text=tempText
