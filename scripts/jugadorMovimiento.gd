extends CharacterBody2D
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var jugadorX=$AnimationPlayer
@onready var textura=$Sprite2D
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("izquierda", "derecha")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
	animations(direction)
	if direction==1:
		textura.flip_h=false
	elif direction==-1:
		textura.flip_h=true
		
func animations(direction):
		if is_on_floor():
			if direction==0:
				jugadorX.play("idle")
			else:
				jugadorX.play("caminarR")
