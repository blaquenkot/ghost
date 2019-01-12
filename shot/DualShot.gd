extends Node2D

var from
var to

func summon_between(first, second):
	from = first
	to = second

	stretch()

func _process(delta):
	stretch()

func stretch():
	position = from.position
	$Beam.set_rotation(to.get_angle_to(from.position))

	var LENGTH_OF_SHOT_SPRITE = 128 # :skull:
	$Beam.transform.x = (from.position - to.position) / LENGTH_OF_SHOT_SPRITE * 2 # ¯\_(ツ)_/¯

func _on_Beam_body_entered(body):
	# TODO: Send "attacked" message instead
	body.queue_free()
