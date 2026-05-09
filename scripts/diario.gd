extends Area2D
func _ready() -> void:
	body_entered.connect(_on_body_entered)
func _on_body_entered(body: Node) -> void:
	#CORRECCION: No está nada bueno usar has_method. Diría que la usemos como último recurso, aquí es más útil definirle una clase al jugador "class_name Jugador" y preguntar "if body is Jugador:", es decir, es mejor saber con qué objeto nos comunicamos en lugar de si tiene o no cierta función, sobre todo si es el jugador.
	if body.has_method("agarrar"):
			body.agarrar("diario")
			queue_free()
