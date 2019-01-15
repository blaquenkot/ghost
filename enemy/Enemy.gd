extends KinematicBody2D

onready var parent = get_parent()

export (int) var speed = 75

func _ready():
	$AnimationPlayer.play('idle')
	
func _physics_process(delta):
	parent.set_offset(parent.get_offset() + speed * delta)

func _on_Area2D_body_entered(body):
	if 'Player' in body.name:
		body.take_damage()

func attacked():
	global.enemyKilledSFXPlayer.play()
	queue_free()