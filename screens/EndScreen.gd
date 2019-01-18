extends CanvasLayer

var main_scene = preload("res://Level.tscn")

func restart_game():
	get_tree().change_scene_to(main_scene)

func _on_RestartButton_pressed():
	restart_game()
