extends Node2D

var DualShot = preload("res://DualShot.tscn")
var current_shot

func _process(delta):
	if Input.is_action_just_pressed("dual_action"):
		current_shot = dual_shot()

	if current_shot:
		adjust_shot(current_shot)

func dual_shot():
	var shot = DualShot.instance()
	$Player1.add_child(shot)
	
	return shot

func adjust_shot(shot):
	shot.position.y = 20
	shot.set_rotation($Player2.get_angle_to($Player1.position))
	
	var LENGTH_OF_SHOT_SPRITE = 64 # :skull:
	shot.transform.x = ($Player1.position - $Player2.position) / LENGTH_OF_SHOT_SPRITE