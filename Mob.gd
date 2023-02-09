extends RigidBody2D

func _ready():
	$AnimatedSprite.playing = true
	
	#Generacion de un Array con los tipos de animacion:
	# ["walk", "swim", "fly"]
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	
	#Escoje un tipo de animacion random dentro de las 3 posibles
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

#Mob se elimina a si mismo al dejar pantalla
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
