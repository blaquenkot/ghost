extends CenterContainer

var main_scene = preload("res://Level.tscn")

func start_game():
	get_tree().change_scene_to(main_scene)

func _on_StartButton_pressed():
	start_game()
