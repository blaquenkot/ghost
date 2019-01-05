extends KinematicBody2D

const GRAVITY = 80
const ACCEL = 100
const JUMP_SPEED = 1000
const MAX_SPEED = 1000
const FRICTION = 0.8

var acc = Vector2()
var vel = Vector2()

var right_action = ''
var left_action = ''
var jump_action = ''

func set_up_actions(player_id):
	right_action = player_id + '_right'
	left_action = player_id + '_left'
	jump_action = player_id + '_jump'
	
func _ready():
    set_physics_process(true)

func _physics_process(delta):
	acc.y = GRAVITY

	if Input.is_action_pressed(right_action):
		acc.x = ACCEL
	elif Input.is_action_pressed(left_action):
		acc.x = -ACCEL
	else:
		acc.x = 0

	vel += acc
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)
	
	if vel.x != 0 && acc.x == 0:
		# TODO: Ensure vel.x reaches 0
		vel.x *= FRICTION
	
	if Input.is_action_just_pressed(jump_action):
		# TODO: Don't jump in the air
		vel.y = -JUMP_SPEED

	move_and_slide(vel)
	
	if collided_with_enemy():
		get_tree().reload_current_scene()

func collided_with_enemy():
	var number_of_collisions = get_slide_count()
	
	for i in range(number_of_collisions):
		var collision = get_slide_collision(i)
		if 'Enemy' in collision.collider.name:
			return true
		
	return false