extends Node2D

const LIGHTNING_GENERATIONS = 5
const LIGHTNING_OFFSET = 5.0

var from
var to

func _ready():
	global.shotSFXPlayer.play()
	
func _process(delta):
	stretch()
	update()

func _draw():
	draw_lightning(from.position, to.position, Color(255, 255, 255), 2)

func summon_between(first, second):
	from = first
	to = second

	stretch()
	
func stretch():
	position = from.position
	$Beam.set_rotation(to.get_angle_to(from.position))
	$Beam.transform.x = (from.position - to.position) / 2 # ¯\_(ツ)_/¯

func _on_Beam_body_entered(body):
	if body.has_method('attacked'):
		body.attacked()

func draw_lightning(from, to, color, width):
	var origin = Vector2(0,0)
	var end = to - from

	var segments = [{'from': origin, 'to': end}] # TODO: Is there a 2x2 matrix structure?
	var offset_limit = LIGHTNING_OFFSET

	for i in range(LIGHTNING_GENERATIONS):
		var current_segments = segments.duplicate()

		for segment in current_segments:
			segments.erase(segment)
			
			var normal = (segment['to'] - segment['from']).normalized().tangent()
			var mid_point = (segment['to'] + segment['from']) / 2
			mid_point = mid_point + normal * rand_range(-LIGHTNING_OFFSET, LIGHTNING_OFFSET)
			
			segments.append({'from': segment['from'], 'to': mid_point    })
			segments.append({'from': mid_point,       'to': segment['to']})

	for segment in segments:
		draw_line(segment['from'], segment['to'], color, width)