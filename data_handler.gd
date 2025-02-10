extends Node

signal startTimer()
signal ingredientsReady()
signal platReady()
signal commandesReady()

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
	var ingredients=[]
	var timer
	var fatana
	var recette =[]
	var statut
	var idCommande
	
	func _init(id, nom, ingredients, timer, fatana, recette):
		self.id=id
		self.nom=nom
		self.ingredients=ingredients
		self.timer=timer
		self.fatana=fatana
		self.recette=recette

class Commande:
	var id
	var commande
	var plat
	var statut
	var deletedAt
	func _init(id, commande, plat, statut, deletedAt):
		self.id = id
		self.commande = commande
		self.plat = plat
		self.statut = statut
		self.deletedAt = deletedAt

var stock_request_queue = []
var processing_stock_request = false
var callRecette=false
var checkRequest=false
var plat_en_attente_de_recette: Plat = null
var ingredientsJoueur: Array[Ingredient]
var platsEnCours: Array[Plat]= [null, null, null]
var commandes: Array[Commande] = []
var platJoueur: Plat
var stocks: Array[Ingredient]
var ingredientsFrigo: Array[Ingredient] = []
var listePlats: Array[Plat] = []
var fullPlat=false
var fullRecette=false
var fullIngredient=false
	
func printIngredientJoueur() -> void:
	for ingredient in ingredientsJoueur:
		print("Ingredient: ",ingredient.nom,",quantité: ",ingredient.quantite)
		

func checkIngredientsJoueur() ->bool:
	var check=false
	for ingredient in ingredientsJoueur:
		if ingredient.quantite>0:
			check=true
			break
	return check

func checkIngredientsRecette(plat: Plat):
	for recIngredient in plat.recette:
		var ingredientTrouve = false
		for joueurIngredient in ingredientsJoueur:
			if joueurIngredient.nom == recIngredient.nom:
				if joueurIngredient.quantite == recIngredient.quantite:
					ingredientTrouve = true
					break
				else:
					return false
		if not ingredientTrouve:
			return false
	platsEnCours[plat.fatana].ingredients=ingredientsJoueur
	startTimer.emit()
	var dt = Time.get_date_dict_from_system()  # Retourne un dictionnaire avec les clés "year", "month", "day", "weekday"
	var dt_str = "%04d-%02d-%02d" % [ dt["year"], dt["month"], dt["day"] ]
	for ingredient in ingredientsJoueur:
		if ingredient.quantite > 0:
			stock_request_queue.append({
				"idIngredient": ingredient.id,
				"quantite": ingredient.quantite,
				"dt": dt_str
			})
	
	# Lancer la première requête si aucune n'est en cours
	if not processing_stock_request:
		process_next_stock_request()
	ingredientsJoueur=[]
	return true

func process_next_stock_request():
	if stock_request_queue.is_empty():
		processing_stock_request = false
		return  # Rien à traiter

	processing_stock_request = true  # Une requête est en cours
	var payload = stock_request_queue.pop_front()  # Récupérer le premier élément de la file
	var json_payload = JSON.stringify(payload)

	# Envoyer la requête API
	%RemoveStock.request(
		"https://cuisine-qemt.onrender.com/api/stock/remove",
		[],  # Pas d'en-têtes personnalisés
		HTTPClient.METHOD_POST,
		json_payload
	)

func printPlat(plat: Plat):
	print("ID:", plat.id,",Nom: ",plat.nom)
	print("Ingredients:")
	for ingredient in plat.ingredients:
		print("nom: ",ingredient.nom, ",quantite: ",ingredient.quantite)
	
func checkIngredientCuisson(indexFatana: int):
	for recIngredient in  platsEnCours[indexFatana].recette:
		var ingredientTrouve = false
		for joueurIngredient in  platsEnCours[indexFatana].ingredients:
			if joueurIngredient.id == recIngredient.id:
				if joueurIngredient.quantite == recIngredient.quantite:
					ingredientTrouve = true
					break
				else:
					return false
		if not ingredientTrouve:
			return false
	return true

func _ready() -> void:
		%ListeIngredients.request("https://cuisine-qemt.onrender.com/api/ingredients")
		%ListePlats.request("https://cuisine-qemt.onrender.com/api/plats")

func _process(delta: float) -> void:
	if checkRequest==false:
		if fullIngredient==true and fullPlat==true and fullRecette==true:
			print("commande api called")
			%Commandes.request("https://cuisine-qemt.onrender.com/api/detailsCommande2")
			checkRequest=true
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("api ingredients called")
	var json = JSON.new()  # Créer une instance de JSON
	var parse_result = json.parse(body.get_string_from_utf8())  # Parser la réponse
	
	if parse_result == OK:  # Vérifier si le parsing a réussi
		var data = json.data  # Récupérer les données parsées (tableau de dictionnaires)
		
		# Remplir le tableau ingredientsFrigo
		ingredientsFrigo.clear()
		for item in data:
			var ingredient = Ingredient.new(item.id, item.nom, null)
			ingredientsFrigo.append(ingredient)

		# Vérification du contenu
		#for ingredient in ingredientsFrigo:
			#print("ID:", ingredient.id, "Nom:", ingredient.nom)
		ingredientsReady.emit()
		fullIngredient=true
	else:
		print("Erreur de parsing JSON")
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_liste_plats_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("api plat called")
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())

	if parse_result == OK:
		var data = json.data  # Récupérer les données parsées (tableau de dictionnaires)
		
		listePlats.clear()
		for item in data:
			var plat = Plat.new(item.id, item.nom, [], item.tempsDePreparation, null,[])
			plat.statut="empty"
			listePlats.append(plat)
		platReady.emit()
		fullPlat=true
		fetch_all_recettes()
	else:
		print("Erreur de parsing JSON")

func fetch_all_recettes() -> void:
	print("Chargement de toutes les recettes via l'API liaisonPlatIngredients2")
	%RecettePlat.request("https://cuisine-qemt.onrender.com/api/liaisonPlatIngredients2")

func _on_recette_plat_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("API recette2 appelée")
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	if parse_result == OK:
		var data = json.data  # data est un tableau de dictionnaires
		# Pour chaque enregistrement, on recherche le plat correspondant dans listePlats
		# et on ajoute l'ingrédient à la recette du plat.
		for item in data:
			# Chaque item contient : id, idPlat, nomPlat, idIngredients, nomIngredients, quantite, deletedAt
			for plat in listePlats:
				if plat.id == item.idPlat:
					var ingr = Ingredient.new(item.idIngredients, item.nomIngredients, item.quantite)
					plat.recette.append(ingr)
					break
		print("Toutes les recettes ont été assignées aux plats.")
		fullRecette=true
	else:
		print("Erreur de parsing JSON pour les recettes (API 2)")

func _on_commandes_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	commandes.clear()
	print("API commandes appelée")
	checkRequest=false
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	
	if parse_result == OK:
		var data = json.data  # Tableau de dictionnaires renvoyé par l'API
		commandes.clear()
		for item in data:
			# Création d'un objet Commande à partir des champs renvoyés par l'API
			var commande_obj = Commande.new(item.id, item.commande, item.plat, item.statut, item.deletedAt)
			commandes.append(commande_obj)
		
		# Vérification du contenu
		#for cmd in commandes:
			#print("Commande id:", cmd.id, " commande:", cmd.commande, " plat:", cmd.plat, " statut:", cmd.statut)
		commandesReady.emit()
	else:
		print("Erreur de parsing JSON pour les commandes")

func getTimer(plat: Plat) -> float:
	# Parcourt la liste des plats pour trouver celui dont l'id correspond à celui du plat passé en paramètre.
	for p in listePlats:
		if p.id == plat.id:
			return p.timer
	# Si aucun plat n'est trouvé, retourne 0 (ou une autre valeur indiquant l'absence de résultat).
	return 0.0


func _on_remove_stock_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		print("Stock mis à jour :", body.get_string_from_utf8())
	else:
		print("Erreur API :", response_code, body.get_string_from_utf8())

	# Traiter la prochaine requête après la réponse de l'API
	process_next_stock_request()
