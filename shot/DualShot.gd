extends Node2D

var from
var to

func summon_between(first, second):
	from = first
	to = second

	stretch()
	
func _process(delta):
	update()
	stretch()

func _draw():
	draw_line(Vector2(0,0), to.position - from.position, Color(255, 0, 0), 5)

func stretch():
	position = from.position
	$Beam.set_rotation(to.get_angle_to(from.position))
	$Beam.transform.x = (from.position - to.position) / 2 # ¯\_(ツ)_/¯

func _on_Beam_body_entered(body):
	# TODO: Send "attacked" message instead
	body.queue_free()
