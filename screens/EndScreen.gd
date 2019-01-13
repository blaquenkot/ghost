extends CanvasLayer

var main_scene = preload("res://Level.tscn")

func _on_Label_gui_input(ev):
	if ev.is_action('ui_click'):
		restart_game()

func restart_game():
	get_tree().change_scene_to(main_scene)
