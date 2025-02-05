extends Node

class Ingredient:
	var id
	var nom
	var quantite
	func _init(id, nom, quantite):
		self.id=id
		self.nom=nom
		self.quantite=quantite
	
class Plat:
	var id
	var nom
	var ingredients: Array[Ingredient] =[]
	var timer
	var fatana
	
	func _init(id, nom, ingredients, timer, fatana):
		self.id=id
		self.nom=nom
		self.ingredients=ingredients
		self.timer=timer
		self.fatana=fatana

var ingredientsJoueur: Array[Ingredient]
var platsEnCours: Array[Plat]= [null, null, null]

func printIngredientJoueur() -> void:
	for ingredient in ingredientsJoueur:
		print("Ingredient: ",ingredient.nom,",quantité: ",ingredient.quantite)
		
