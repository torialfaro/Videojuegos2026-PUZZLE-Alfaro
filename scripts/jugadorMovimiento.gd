extends CharacterBody2D
const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const TREPAR_VELOCIDAD = 100.0
@onready var jugadorX=$AnimationPlayer
@onready var textura=$Sprite2D
@onready var activarPalanca:Area2D = $detectarPalanca
@onready var popup = get_node("/root/nivel1/CanvasLayer")

var enEscalera:bool
var trepar:bool
var direction:float=0.0
var ultima_direccion: float = 1.0
var palanca_cercana: Area2D = null
var tieneDiario:bool=false


func _ready() -> void:
	activarPalanca.area_entered.connect(_on_activarPalanca_entered)
	activarPalanca.area_exited.connect(_on_activarPalanca_exited)
func _on_activarPalanca_entered(area: Area2D) -> void:
	if area.has_method("accionar"):
		palanca_cercana = area
func _on_activarPalanca_exited(area: Area2D) -> void:
	if area == palanca_cercana:
		palanca_cercana = null
func _on_area_2d_body_entered(body: Node2D) -> void:
	enEscalera=true
func _on_area_2d_body_exited(body: Node2D) -> void:
	enEscalera=false
	trepar = false 
	jugadorX.play("idle")
	
func _physics_process(delta: float) -> void:
	var enPiso=is_on_floor()
	direction= Input.get_axis("izquierda", "derecha")
	if direction != 0.0:
		ultima_direccion = direction 
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
	if Input.is_action_just_pressed("accionarPal") and palanca_cercana != null:
		palanca_cercana.accionar(direction)
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
func agarrar(objeto: String) -> void:
	if objeto == "diario":
		tieneDiario = true
		popup.mostrar()
