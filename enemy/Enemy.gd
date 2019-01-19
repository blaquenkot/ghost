extends KinematicBody2D

export(Color, RGBA) var dead_animation_color
export(int) var dead_particles_size = 2 

var DeadAnimation = preload("res://enemy/DeadAnimation.tscn")

onready var parent = get_parent()

export (int) var speed = 75

func _ready():
	$AnimationPlayer.play('idle')
	
func _physics_process(delta):
	parent.set_offset(parent.get_offset() + speed * delta)

func _on_Area2D_body_entered(body):
	if 'Player' in body.name:
		body.take_damage((position - body.position).normalized())

func attacked():
	die()
	
func die():
	global.enemyKilledSFXPlayer.play()
	disappear()
	show_death_animation()
	$DieTimer.start()
	
func show_death_animation():
	var animation = DeadAnimation.instance()
	animation.init(dead_animation_color, dead_particles_size, $Sprite.region_rect.size.x)
	speed = 0
	add_child(animation)
	
func disappear():
	$Sprite.hide()
	$CollisionShape2D.disabled = true
	$Area2D.monitoring = false

func _on_DieTimer_timeout():
	queue_free()
