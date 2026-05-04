extends Area2D
@export var trigger: int = 0
signal palancaActivada
const estado = {
	"desactivada": preload("res://assets/palancaArriba.png"),
	"activada": preload("res://assets/palancaAbajo.png") }
var direccion: int = 1
@onready var cosasAccionables: Node2D = get_parent().get_node("accionables")

@onready var sprite: Sprite2D = get_node("Sprite2D")
func _ready() -> void:
	if trigger != 0:
		for accionable in cosasAccionables.get_children():
			if accionable.trigger == trigger:
				palancaActivada.connect(accionable._change_state)
	else:
		print("trigger es 0, no conecta nada")

func accionar(dir: int) -> void:
	direccion = dir
	sprite.texture = estado["desactivada"] if dir == 1 else estado["activada"]
	palancaActivada.emit()
