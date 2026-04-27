extends CharacterBody2D
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const TREPAR_VELOCIDAD = 100.0
@onready var jugadorX=$AnimationPlayer
@onready var textura=$Sprite2D

var enEscalera:bool
var trepar:bool

func entraUnJugador(_body:Node2D)

func _physics_process(delta: float) -> void:
	var enPiso=is_on_floor()
	var direction := Input.get_axis("izquierda", "derecha")
	if enEscalera:
		var direccion_y=Input.get_axis("arriba","abajo")
		if direccion_y:
			velocity.y=direccion_y*TREPAR_VELOCIDAD
			trepar=not enPiso
		else:
			velocity.y=move_toward(velocity.y,0,TREPAR_VELOCIDAD)
			if enPiso:trepar=false
		if trepar:
			if direccion_y:jugadorX.play("trepar")
			else: jugadorX.play("idle")
	elif not enPiso:
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("saltar") and not trepar:
		velocity.y = JUMP_VELOCITY
		
	if direction:
		velocity.x = direction * SPEED
		if enEscalera:trepar=not enPiso
		else:trepar=false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not trepar:jugadorX.play("idle")
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
	
