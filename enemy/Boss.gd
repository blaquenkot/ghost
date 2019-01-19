extends KinematicBody2D

signal boss_attacked(new_health)

onready var parent = get_parent()

var DeadAnimation = preload("res://enemy/DeadAnimation.tscn")

export (int) var speed = 120

var health = 6
var alive = true

var can_take_damage = true

func _ready():
	$AnimationPlayer.play('idle')
	
func _physics_process(delta):
	if visible && alive:
		parent.set_offset(parent.get_offset() + speed * delta)
	
func attacked():
	if can_take_damage:
		global.enemyKilledSFXPlayer.play()
		health -= 1
		emit_signal('boss_attacked', health)
		if health <= 0:
			killed()
		else:
			can_take_damage = false
			$InvincibilityTimer.start()
			$FlashTimer.start()
			
func killed():
	alive = false
	
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	$CollisionShape2D3.disabled = true
	$CollisionShape2D4.disabled = true
	$CollisionShape2D5.disabled = true
	set_collision_mask_bit(2, false)

	global.bossKilledSFXPlayer.play()

	show_death_animation()

	$KilledTimer.start()

func show_death_animation():
	var animation = DeadAnimation.instance()
	animation.init(Color(0,0,0), 4, $Sprite.region_rect.size.x)
	add_child(animation)

func _on_Timer_timeout():
	$Sprite.modulate = Color(1,1,1,1)
	$FlashTimer.stop()
	can_take_damage = true

func _on_FlashTimer_timeout():
	if $Sprite.modulate == Color(1,1,1,0.2):
		$Sprite.modulate = Color(1,0,0,1)
	else: 
		$Sprite.modulate = Color(1,1,1,0.2)

func _on_KilledTimer_timeout():
	if $Sprite.modulate == Color(1,1,1,1):
		$Sprite.modulate = Color(1,0,0,1)
	elif $Sprite.modulate == Color(1,0,0,1): 
		$Sprite.modulate = Color(0,1,0,1)
	elif $Sprite.modulate == Color(0,1,0,1): 
		$Sprite.modulate = Color(0,0,1,1)
	elif $Sprite.modulate == Color(0,0,1,1):
		$Sprite.modulate = Color(0,0,0,1)
	else:
		$KilledTimer.stop()
		queue_free()