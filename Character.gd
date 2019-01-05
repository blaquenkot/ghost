extends KinematicBody2D

const GRAVITY = 20
const ACCEL = 1500
const MAX_SPEED = 500
const FRICTION = -500

var acc = Vector2()
var vel = Vector2()

func _ready():
    set_physics_process(true)

func _physics_process(delta):
	acc.y = GRAVITY
	vel += acc * delta
	
	move_and_collide(vel)