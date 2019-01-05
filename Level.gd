extends Node2D
	
var padding = 64
	
func _process(delta):
	$Camera2D.position.x = abs($Player1.position.x - $Player2.position.x) * 0.5 + min($Player1.position.x, $Player2.position.x)

	var limits = get_limits()	

	$Player1.min_x = limits["min"]
	$Player1.max_x = limits["max"]
	$Player2.min_x = limits["min"]
	$Player2.max_x = limits["max"]

func get_limits():
	var ctrans = get_canvas_transform()
	var min_pos = -ctrans.get_origin() / ctrans.get_scale()
	var view_size = get_viewport_rect().size / ctrans.get_scale()
	var max_pos = min_pos + view_size
	
	return {"min": min_pos.x + padding, "max": max_pos.x - padding}