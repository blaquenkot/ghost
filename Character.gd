extends KinematicBody2D

const GRAVITY = 40
const ACCEL = 50
const JUMP_SPEED = 500
const MAX_SPEED = 500
const FRICTION = 0.8
const BOUNCE_BACK_SPEED = 5

signal character_took_damage

var can_take_damage = true
var can_be_controlled = true

var acc = Vector2()
var vel = Vector2()

var min_pos = Vector2()
var max_pos = Vector2()

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

	if can_be_controlled:
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
	
	if is_on_floor():
		if can_be_controlled:
			if Input.is_action_just_pressed(jump_action):
				global.jumpSFXPlayer.play()
				vel.y = -JUMP_SPEED
		elif randf() > 0.97:
			global.jumpSFXPlayer.play()
			vel.y = -JUMP_SPEED

	move_and_slide(vel, Vector2(0, -1), 10, 4, 1.5)

func take_damage(collision_normal):
	if can_take_damage:
		vel = vel.bounce(collision_normal) * BOUNCE_BACK_SPEED
		vel.y = -JUMP_SPEED / 2
		can_take_damage = false
		$InvincibilityTimer.start()
		$FlashTimer.start()
		global.hitSFXPlayer.play()
		emit_signal('character_took_damage')
	
func can_move():
	if (position.y < min_pos.y):
		return vel.y > 0
	elif (position.y > max_pos.y):
		return vel.y <0
	elif (position.x < min_pos.x):
		return vel.x > 0
	elif (position.x > max_pos.x):
		return vel.x <0
	
	return true

func _on_Timer_timeout():
	$Sprite.modulate = Color(1,1,1,1)
	$FlashTimer.stop()
	can_take_damage = true
	
	var colliding_body = $ThreatDetectionArea.get_overlapping_bodies().front()
	
	if colliding_body:
		on_hit_by_enemy(colliding_body)
	elif !$ThreatDetectionArea.get_overlapping_areas().empty():
		on_hit_by_floor()

func _on_FlashTimer_timeout():
	if $Sprite.modulate == Color(1,1,1,1):
		$Sprite.modulate = Color(10,10,10,1)
	else: 
		$Sprite.modulate = Color(1,1,1,1)
		
func on_hit_by_enemy(body):
	take_damage((body.position - position).normalized())
	
func on_hit_by_floor():
	take_damage(Vector2(0, -1))

func _on_ThreatDetectionArea_body_entered(body):
	on_hit_by_enemy(body)

func _on_ThreatDetectionArea_area_entered(area):
	on_hit_by_floor()

