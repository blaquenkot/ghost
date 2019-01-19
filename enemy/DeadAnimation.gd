extends Node2D

export(Color) var color = Color(1, 0, 1)
export(int) var size = 2
export(int) var width = 10
export(float) var timeoff
export(bool) var explode = false

func init(color, size, width):
	self.color = color
	self.size = size
	self.width = width
	
func set_expiration_time(time):
	timeoff = time
	
func set_explode(should_explode):
	explode = should_explode

func _ready():
	for i in range(20):
		var particle = create_particle()
		var horizontal_impulse = randf() * 100 - 50
		var vertical_impulse = randi() % 100 - 150 if explode else randi() % 10 - 20
		particle.apply_impulse(Vector2(0, 0), Vector2(horizontal_impulse, vertical_impulse))
		add_child(particle)
		
	if timeoff:
		$ExpireTimer.set_wait_time(timeoff)
		$ExpireTimer.start()

func create_particle():
	var body = RigidBody2D.new()

	body.set_collision_layer_bit(0, false)
	body.set_collision_layer_bit(5, true)
	body.set_collision_mask_bit(0, true)
	body.set_gravity_scale(3)
	
	var collider = CollisionShape2D.new()
	collider.position = Vector2(size / 2, size / 2)
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(size / 2, size / 2))
	collider.set_shape(shape)
	body.add_child(collider)
	
	var geometry = Polygon2D.new()
	var points = PoolVector2Array()
	points.push_back(Vector2(0, 0))
	points.push_back(Vector2(size, 0))
	points.push_back(Vector2(size, size))
	points.push_back(Vector2(0, size))
	geometry.set_polygon(points)
	geometry.set_color(color)
	body.add_child(geometry)
	
	return body

func _on_ExpireTimer_timeout():
	queue_free()
