extends TileMap

@export var map_width: int = 71
@export var map_height: int = 40

const LAYER = 0
const TILESET_SOURCE = 0
const BLACK: Vector2i = Vector2i(0, 0)
const WHITE: Vector2i = Vector2i(1, 0)
const BLUE: Vector2i = Vector2i(0, 1)
const GREEN: Vector2i = Vector2i(1, 1)


func _ready():
	var rooms = create_graph()
	render_tilemap(rooms)
	

func create_graph() -> Array[Segment]:
	var rooms: Array[Segment] = []
	# Entrance room
	var entrance = Segment.new()
	entrance.size = Vector2i(3, 3)
	entrance.position = Vector2i(map_width / 2 - 1, map_height - 2)
	rooms.append(entrance)
	# Connecting rooms
	var room = Segment.new()
	entrance.connections.append(room)
	room.size = Vector2i(randi_range(2, 6), randi_range(2, 6))
	room.position = Vector2i( 25, 23)
	rooms.append(room)
	return rooms
	

func render_tilemap(rooms: Array[Segment]):
	for x in range(map_width):
		for y in range(map_height):
			set_cell(LAYER, Vector2i(x, y), TILESET_SOURCE, BLACK)
	for room in rooms:
		var start = room.position - (room.size / 2)
		for x in range(room.size.x):
			for y in range(room.size.y):
				set_cell(LAYER, Vector2i(start.x + x, start.y + y), TILESET_SOURCE, WHITE)
	var connectionZone = Segment.new()
	connectionZone.size = Vector2i(10, 19)
	connectionZone.position = Vector2i(32, 27)
	var start = connectionZone.position - (connectionZone.size / 2)
	for x in range(connectionZone.size.x):
			for y in range(connectionZone.size.y):
				set_cell(LAYER, Vector2i(start.x + x, start.y + y), TILESET_SOURCE, BLUE)

func cellular_automata():
	pass
