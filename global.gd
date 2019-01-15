extends Node

onready var jumpSFXPlayer = get_node("JumpSFXPlayer") 
onready var shotSFXPlayer = get_node("ShotSFXPlayer") 

func _ready():
	OS.set_window_maximized(true)
