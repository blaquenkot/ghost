extends KinematicBody2D

signal boss_attacked(new_health)

onready var parent = get_parent()

export (int) var speed = 120

var health = 5
var can_take_damage = true

func _ready():
	$AnimationPlayer.play('idle')
	
func _physics_process(delta):
	if visible:
		parent.set_offset(parent.get_offset() + speed * delta)
	
func attacked():
	if can_take_damage:
		global.enemyKilledSFXPlayer.play()
		health -= 1
		emit_signal('boss_attacked', health)
		if health <= 0:
			queue_free()
		else:
			can_take_damage = false
			$InvincibilityTimer.start()
			$FlashTimer.start()
			
func _on_Timer_timeout():
	$Sprite.modulate = Color(1,1,1,1)
	$FlashTimer.stop()
	can_take_damage = true

func _on_FlashTimer_timeout():
	if $Sprite.modulate == Color(1,1,1,1):
		$Sprite.modulate = Color(1,0,0,1)
	else: 
		$Sprite.modulate = Color(1,1,1,1)