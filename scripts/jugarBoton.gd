extends TextureRect
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#CORRECCION: No entiendo porqué el timer, si la respuesta es "para que espere un cachito antes de cambiar de escena" sigo sin entender porqué se quiere eso. Si hubiese una animación esa sería la razón.
		#Además, investigá qué es un TextureButton, para no tener que hacer esta función y usar solo una señal.
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://escenas/nivel1.tscn")
