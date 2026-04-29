extends CharacterBody2D
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const TREPAR_VELOCIDAD = 100.0
@onready var jugadorX=$AnimationPlayer
@onready var textura=$Sprite2D

var enEscalera:bool
var trepar:bool

func _on_area_2d_body_entered(body: Node2D) -> void:
	enEscalera=true
func _on_area_2d_body_exited(body: Node2D) -> void:
	enEscalera=false
	jugadorX.play("idle")
	
func _physics_process(delta: float) -> void:
	var enPiso=is_on_floor()
	var direction := Input.get_axis("izquierda", "derecha")
	if enEscalera:
		var direccion_y=Input.get_axis("saltar","abajo")
		if direccion_y!=0:
			velocity.y=direccion_y*TREPAR_VELOCIDAD
			trepar=not enPiso
		else:
			velocity.y=move_toward(velocity.y,0,TREPAR_VELOCIDAD)
			if enPiso:trepar=false
		if trepar:
			if direccion_y!=0:jugadorX.play("trepar")
			else: jugadorX.play("idle")
	elif not enPiso:
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("saltar") and not trepar:
		velocity.y = JUMP_VELOCITY
		
	if direction != 0:
		velocity.x = direction * SPEED
		textura.flip_h = direction < 0
		if enEscalera:
			trepar = not enPiso
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	if not trepar:animations(direction)
func animations(direction):
		if is_on_floor():
			if direction==0:
				jugadorX.play("idle")
			else:
				jugadorX.play("caminarR")
