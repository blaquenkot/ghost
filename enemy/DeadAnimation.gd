extends Node2D

export(Color) var color = Color(1, 0, 1)
export(int) var size = 2
export(int) var width = 10

func init(color, size, width):
	self.color = color
	self.size = size
	self.width = width

func _ready():
	for i in range(20):
		var particle = create_particle()
		particle.apply_impulse(Vector2(0, 0), Vector2(randf() * 100 - 50, randi() % 10 - 20))
		add_child(particle)

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