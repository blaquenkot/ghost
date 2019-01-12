extends KinematicBody2D

const GRAVITY = 40
const ACCEL = 50
const JUMP_SPEED = 500
const MAX_SPEED = 500
const FRICTION = 0.8

signal character_took_damage

var can_take_damage = true

var acc = Vector2()
var vel = Vector2()

var min_x = 0
var max_x = 0

var right_action = ''
var left_action = ''
var jump_action = ''

func set_up_actions(player_id):
	right_action = player_id + '_right'
	left_action = player_id + '_left'
	jump_action = player_id + '_jump'
	
func _ready():
	set_physics_process(true)
	$AnimationPlayer.play('idle')

func _physics_process(delta):
	if is_on_floor():
		acc.y = 0
	else:
		acc.y = GRAVITY

	if Input.is_action_pressed(right_action):
		acc.x = ACCEL
	elif Input.is_action_pressed(left_action):
		acc.x = -ACCEL
	else:
		acc.x = 0

	# TODO: Add terminal velocity in y
	vel += acc
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)
	
	if vel.x != 0 && acc.x == 0:
		# TODO: Ensure vel.x reaches 0
		vel.x *= FRICTION
		
	$Sprite.flip_h = (vel.x < 0)
		
	if !can_move():
		vel.x = 0
	
	if is_on_floor() && Input.is_action_just_pressed(jump_action):
		vel.y = -JUMP_SPEED

	move_and_slide(vel, Vector2(0, -1))
	
	if can_take_damage and collided_with_enemy():
		can_take_damage = false
		$InvincibilityTimer.start()
		$FlashTimer.start()
		emit_signal('character_took_damage')

func collided_with_enemy():
	var number_of_collisions = get_slide_count()
	
	for i in range(number_of_collisions):
		var collision = get_slide_collision(i)
		if 'Enemy' in collision.collider.name || 'DeathlyObstacle' in collision.collider.name: # lol
			return true
		
	return false
	
func can_move():
	if (position.x < min_x):
		return vel.x > 0
	elif (position.x > max_x):
		return vel.x <0
	
	return true

func _on_Timer_timeout():
	$Sprite.modulate = Color(1,1,1,1)
	$FlashTimer.stop()
	can_take_damage = true

func _on_FlashTimer_timeout():
	if $Sprite.modulate == Color(1,1,1,1):
		$Sprite.modulate = Color(10,10,10,1)
	else: 
		$Sprite.modulate = Color(1,1,1,1)