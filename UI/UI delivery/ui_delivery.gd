extends CanvasLayer
var plat
var url
var idCommande
var okToSend=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if DataHandler.platJoueur:
		plat=DataHandler.platJoueur.nom
		%RichTextLabel.text= "Vous allez livrer ce plat: "+plat
		print("Plat delivery nom :",plat)


func _on_button_2_button_up() -> void:
	self.hide()


func _on_button_button_up() -> void:
	#DataHandler.platJoueur.statut=1
	#DataHandler.commandeEnvoyes.append(DataHandler.platJoueur)
	if okToSend==true:
		print("idCommande avant appel api=",str(idCommande))
		url="https://cuisine-qemt.onrender.com/api/detailsCommande/"+str(idCommande)+"/livrer"
		%HTTPRequest.request(url,PackedStringArray(),HTTPClient.METHOD_PUT)
		DataHandler.platJoueur=null
		self.hide()
		okToSend=false


func _on_spin_box_value_changed(value: float) -> void:
	idCommande=value
	okToSend=true
	


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print(str(idCommande))
	print("commande livrée")
