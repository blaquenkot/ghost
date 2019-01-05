extends KinematicBody2D

const GRAVITY = 20
const ACCEL = 80
const MAX_SPEED = 5000
const FRICTION = 0.95

var acc = Vector2()
var vel = Vector2()

func _ready():
    set_physics_process(true)

func _physics_process(delta):
	acc.y = GRAVITY
	
	if Input.is_action_pressed('player1_right'):
		acc.x = ACCEL
	elif Input.is_action_pressed('player1_left'):
		acc.x = -ACCEL
	else:
		acc.x = 0
		
	vel += acc
	
	vel.x *= FRICTION
	
	move_and_slide(vel)