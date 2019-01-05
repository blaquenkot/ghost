extends Node2D

var padding = 64
var DualShot = preload("res://DualShot.tscn")
var current_shot

func _process(delta):
	$Camera2D.position.x = abs($Player1.position.x - $Player2.position.x) * 0.5 + min($Player1.position.x, $Player2.position.x)

	var limits = get_limits()	

	$Player1.min_x = limits["min"]
	$Player1.max_x = limits["max"]
	$Player2.min_x = limits["min"]
	$Player2.max_x = limits["max"]

	if !current_shot && Input.is_action_just_pressed("dual_action"):
		current_shot = dual_shot()

	if current_shot:
		adjust_shot(current_shot)

func dual_shot():
	var shot = DualShot.instance()
	$ShotTimer.start()
	$Player1.add_child(shot)
	
	return shot

func adjust_shot(shot):
	shot.position.y = 20
	shot.set_rotation($Player2.get_angle_to($Player1.position))
	
	var LENGTH_OF_SHOT_SPRITE = 64 # :skull:
	shot.transform.x = ($Player1.position - $Player2.position) / LENGTH_OF_SHOT_SPRITE

func get_limits():
	var ctrans = get_canvas_transform()
	var min_pos = -ctrans.get_origin() / ctrans.get_scale()
	var view_size = get_viewport_rect().size / ctrans.get_scale()
	var max_pos = min_pos + view_size
	
	return {"min": min_pos.x + padding, "max": max_pos.x - padding}

func _on_ShotTimer_timeout():
	current_shot.queue_free()
	current_shot = null
	$ShotTimer.stop()