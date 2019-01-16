extends Node2D

var padding = Vector2(64,64)
var DualShot = preload("res://shot/DualShot.tscn")
var Sparks = preload("res://shot/Sparks.tscn")
var EndScreen = preload("res://screens/EndScreen.tscn")
var current_shot

var lives = 6

func _process(delta):
	if $Player1 && $Player2:
		$Camera2D.position.x = abs($Player1.position.x - $Player2.position.x) * 0.5 + min($Player1.position.x, $Player2.position.x)
		$Camera2D.position.y = abs($Player1.position.y - $Player2.position.y) * 0.5 + min($Player1.position.y, $Player2.position.y)

		var limits = get_limits()	
	
		$Player1.min_pos = limits["min"]
		$Player1.max_pos = limits["max"]
		$Player2.min_pos = limits["min"]
		$Player2.max_pos = limits["max"]
	
		if !current_shot && Input.is_action_just_pressed("dual_action"):
			current_shot = dual_shot()

func dual_shot():
	var shot = DualShot.instance()
	add_child(shot)
	$ShotTimer.start()
	shot.summon_between($Player1, $Player2)

	# create_sparks_at($Player1.position)
	# create_sparks_at($Player2.position)
	
	return shot

func create_sparks_at(position):
	var particles = Sparks.instance()
	particles.position = position
	add_child(particles)
	particles.emitting = true

func get_limits():
	var ctrans = get_canvas_transform()
	var min_pos = -ctrans.get_origin() / ctrans.get_scale()
	var view_size = get_viewport_rect().size / ctrans.get_scale()
	var max_pos = min_pos + view_size
	
	return {"min": min_pos + padding, "max": max_pos - padding}

func _on_ShotTimer_timeout():
	if current_shot:
		current_shot.queue_free()
		current_shot = null
		
	$ShotTimer.stop()
	
func _on_player_took_damage():
	lives -= 1
	if lives <= 0:
		the_end()
	else:
		$CanvasLayer/MarginContainer/TextureRect.texture = load("res://assets/health/health%s.png" % lives)
		
func the_end():
	global.gameOverSFXPlayer.play()
	var end_screen = EndScreen.instance()
	
	if current_shot:
		current_shot.queue_free()
		current_shot = null
		
	$Player1.queue_free()
	$Player2.queue_free()
	
	add_child(end_screen)
	# get_tree().reload_current_scene()