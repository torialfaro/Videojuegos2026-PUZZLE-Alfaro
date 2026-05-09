extends CharacterBody2D
const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const TREPAR_VELOCIDAD= 100.0
const UMBRAL_CAIDA = 600.0
@onready var jugadorX=$AnimationPlayer
@onready var textura=$Sprite2D
@onready var activarPalanca:Area2D = $detectarPalanca


#CORRECCION: No es que esté mal que haya variables que luego no se utilizan, pero nos complica un poco el trabajo después. La idea es que mirar las propiedades de la clase ya nos de un pequeño panorama de lo que hace, de qué se encarga.
var enEscalera:bool
var trepar:bool
var direction:float=0.0
var ultima_direccion: float = 1.0
var palanca_cercana: Area2D = null
var tieneDiario:bool=false
var velocidad_caida: float = 0.0
var cayendo: bool = false
var estaMuerta: bool = false 
var puedeSaltar:bool=false

func _ready() -> void:
	#CORRECCION: Por qué no hiciste lo mismo que con detectarEscalera donde configuraste por inspector???? sus
	activarPalanca.area_entered.connect(_on_activarPalanca_entered)
	activarPalanca.area_exited.connect(_on_activarPalanca_exited)
func _on_activarPalanca_entered(area: Area2D) -> void:
	if area.has_method("accionar"):
		palanca_cercana = area
func _on_activarPalanca_exited(area: Area2D) -> void:
	#CORRECCION: Esta solución no me disgusta, activar y desactivar qué tenemos cerca. Lo que pasa aquí es que a medida que el juego avance vamos a empezar a tener problemas, qué pasa si hay un cofre, o bill está cerca, vamos a tener cofre_cercano y bill_cercano? En seguida se nos va de las manos. Esto se suele usar para que la palanca muestre sobre sí misma el botón a apretar por ejemplo, pero se manejaría desde la palanca. En este caso luego de presionar el botón me fijaría si estoy cerca de una palanca y listo.
	if area == palanca_cercana:
		palanca_cercana = null
func _on_area_2d_body_entered(body: Node2D) -> void:
	enEscalera=true
func _on_area_2d_body_exited(body: Node2D) -> void:
	enEscalera=false
	trepar = false 
	jugadorX.play("idle")
	
func _physics_process(delta: float) -> void:
	if estaMuerta:
		return
	var enPiso=is_on_floor()
	if enPiso:
		puedeSaltar = true
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
		if velocity.y > 0:
			velocidad_caida = velocity.y
			cayendo = true
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("saltar") and not trepar and puedeSaltar:
		velocity.y = JUMP_VELOCITY
		puedeSaltar = false 

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
	
	if enPiso and cayendo:
		if velocidad_caida >= UMBRAL_CAIDA:
			morir()
			return 
		cayendo = false
		velocidad_caida = 0.0
		
	if not trepar:animations(direction)
func morir() -> void:
	estaMuerta = true
	velocity = Vector2.ZERO
	jugadorX.play("muerte")
	await get_tree().create_timer(2.0).timeout
	get_tree().current_scene.get_node("popUpPerdiste").mostrar()
	await get_tree().create_timer(2.0).timeout 
	get_tree().reload_current_scene()
func animations(direction):
		if is_on_floor():
			if direction==0:
				jugadorX.play("idle")
			else:
				jugadorX.play("caminarR")
func agarrar(objeto: String) -> void:
	#CORRECCION: De momento Mabel no agarra otra cosa, así que es medio innecesario fijarse si es un diario. Además, si configurás bien los layers y mask de colisión ni siquiera va a llegar aquí una colisión que no sea con un diario, por lo tanto no necesitaríamos tampoco hacer esta pregunta.
	if objeto == "diario":
		tieneDiario = true
		get_tree().current_scene.get_node("popUp").mostrar()
		await get_tree().create_timer(2.0).timeout
		var escena_actual = get_tree().current_scene.scene_file_path
		if escena_actual == "res://escenas/nivel1.tscn":
			get_tree().change_scene_to_file("res://escenas/nivel2.tscn")
		elif escena_actual == "res://escenas/nivel2.tscn":
			get_tree().change_scene_to_file("res://escenas/menu.tscn")
			
