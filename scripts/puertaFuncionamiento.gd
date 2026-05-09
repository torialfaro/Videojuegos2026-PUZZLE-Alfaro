extends StaticBody2D

#CORRECCION: Estamos teniendo un código que deshabilita una colisión que jamás colisionaba con Mabel. Es un síntoma de no probar bien el juego esto. Mabel es layer 1 y mask 1, la puerta es layer 4 y mask 4. En ningún momento le estamos diciendo ahí a Mabel que debería detectar colisión con la puerta, Tanto mabel y la puerta se están detectando a sí mismas, pero no a la otra.
@export var trigger: int = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var abierta: bool = false
func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
func abrir(boolean: bool) -> void:
	if boolean:
		animated_sprite_2d.play("abrir")
	else:
		animated_sprite_2d.play_backwards("abrir")
		$CollisionShape2D.disabled = false
		
func _on_animation_finished() -> void:
	if abierta:
		$CollisionShape2D.disabled = true
func _change_state() -> void:
	if not abierta:
		abierta = true
		abrir(true)
