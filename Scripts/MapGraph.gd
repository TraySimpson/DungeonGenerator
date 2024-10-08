class_name MapGraph
extends RefCounted

@export var max_connections: int = 3
@export var longest_depth: int = 5

var root: Segment
var segments: Array [Segment] = []
var rng: RandomNumberGenerator

func init(generator: RandomNumberGenerator) -> void:
	rng = generator

func generate_graph(room_count: int) -> void:
	segments = []
	
	# Entrance room
	root = Segment.new()
	root.size = Vector2i(8, 8)
	segments.append(root)
	
	# Connecting rooms
	for i in range(room_count):
		var room = Segment.new()
		root.connections.append(room)
		room.size = Vector2i(rng.randi_range(4, 20), rng.randi_range(4, 20))
		segments.append(room)

func generate_room_positions(mapSize: Vector2i) -> void:
	generate_child_positions([ root ] , mapSize)

func generate_child_positions(segments: Array[Segment], mapSize: Vector2i) -> void:
	if (segments.is_empty()):
		return
	for segment in segments:
		segment.position = Vector2i(
			rng.randi_range(0, mapSize.x),
			rng.randi_range(0, mapSize.y)
		)
		generate_child_positions(segment.connections, mapSize)
