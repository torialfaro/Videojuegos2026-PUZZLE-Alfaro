extends TextureRect
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://escenas/nivel1.tscn")
