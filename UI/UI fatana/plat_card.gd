extends Control

signal selection(name: String)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func init(nom: String) -> void:
	%PlatName.text=nom
	


func _on_button_button_up() -> void:
	selection.emit(%PlatName.text)
