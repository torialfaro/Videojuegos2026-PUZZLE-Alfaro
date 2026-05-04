extends CanvasLayer
@onready var label: Label = $TextureRect/Label

func mostrar() -> void:
	visible = true
	await get_tree().create_timer(2.0).timeout
	visible = false
