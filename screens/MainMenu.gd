extends MarginContainer

var main_scene = preload("res://Level.tscn")

func start_game():
	get_tree().change_scene_to(main_scene)


func _on_StartButton_gui_input(ev):
	if ev.is_action('ui_click'):
		start_game()

