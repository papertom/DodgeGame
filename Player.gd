extends Area2D
signal hit

export var speed = 400 #que tan rapido se mueve el personaje (pixel/sec)
var screen_size #tamaño de la ventana de juego



func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta):
	
	#INPUTS DE MOVIMIENTO
	var velocity = Vector2.ZERO #Vector de mov. del player.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	#ACTIVA ANIMACION Y NORMALIZA VELOCIDAD
	if velocity.length() > 0:
		velocity = velocity.normalized()*speed #Evita diag mov + rapido.
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	#ACTUALIZA LA UBICACION DEL PERSONAJE
	position += velocity*delta
	
	#EVITAR QUE PERSONAJE SALGA DE LA PANTALLA
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#SELECCION DE ANIMACION SEGUN ACCION
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	#elif velocity.y != 0:
	#	$AnimatedSprite.animation = "up"
	#	$AnimatedSprite.flip_v = velocity.y > 0
	

#DETECTA SI UN OBJETO TOCA AL PERSONAJE
func _on_Player_body_entered(_body):
	hide() #El personaje desaparece tras ser impactado.
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true) #Evita golpes multiples

#REINICIA EL PERSONAJE AL INICIAR NUEVO JUEGO
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
