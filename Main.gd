extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free") #Todos los mobs se destruyen
	$Music.play()
	$DeathSound.stop()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout():
	#Crear Mob instance
	var mob = mob_scene.instance()
	
	#Selecciona una ubicacion al azar en el Path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	#Define un camino perpendicular para Mob
	var direction = mob_spawn_location.rotation + PI / 2
	
	#Escoge una ubicacion al azar para mob spawn
	mob.position = mob_spawn_location.position
	
	#Añade azar a la trayectoria de los Mob
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#Define una velocidad para el mob instanciado
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#Spawnea al mob añadiendolo a Main scene
	add_child(mob)
