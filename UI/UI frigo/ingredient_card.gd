extends Control

var quantity=0
var ing=null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func init(ingredient: DataHandler.Ingredient) -> void:
	%IngredientName.text=ingredient.nom
	ing=ingredient


func _on_spin_box_value_changed(value: float) -> void:
	quantity=value
	
func getQuantity() -> Array:
	return [ing.id,%IngredientName.text,quantity]
