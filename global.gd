extends Node

onready var jumpSFXPlayer = get_node("JumpSFXPlayer") 
onready var shotSFXPlayer = get_node("ShotSFXPlayer") 
onready var hitSFXPlayer = get_node("HitSFXPlayer") 
onready var potionSFXPlayer = get_node("PotionSFXPlayer") 
onready var gameOverSFXPlayer = get_node("GameOverSFXPlayer") 
onready var enemyKilledSFXPlayer = get_node("EnemyKilledSFXPlayer") 

func _ready():
	OS.set_window_maximized(true)
