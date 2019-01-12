extends KinematicBody2D

onready var parent = get_parent()

export (int) var speed = 75

func _ready():
	$AnimationPlayer.play('idle')
	
func _physics_process(delta):
	parent.set_offset(parent.get_offset() + speed * delta)
