extends KinematicBody2D

const GRAVITY = 20
const ACCEL = 80
const MAX_SPEED = 5000
const FRICTION = 0.95

var acc = Vector2()
var vel = Vector2()

var right_action = ''
var left_action = ''

func set_up_actions(player_id):
	right_action = player_id + '_right'
	left_action = player_id + '_left'
	
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
	
	vel.x *= FRICTION
	
	move_and_slide(vel)