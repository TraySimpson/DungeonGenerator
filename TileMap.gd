extends TileMap

@export var map_width: int = 71
@export var map_height: int = 40

const LAYER = 0
const TILESET_SOURCE = 0
const BLACK: Vector2i = Vector2i(0, 0)
const WHITE: Vector2i = Vector2i(1, 0)



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
	var connectingRoomCount = randi_range(1, 4)
	for roomIndex in connectingRoomCount:
		var room = Segment.new()
		entrance.connections.append(room)
		room.size = Vector2i(randi_range(2, 6), randi_range(2, 6))
		rooms.append(room)
	calculate_weight(entrance)
	calculate_connected_positions(entrance)
	return rooms
	
func calculate_weight(segment: Segment) -> int:
	if (segment.connections.is_empty()):
		segment.weight = segment.get_room_weight()
		return segment.weight
	var weight = 0
	for connection in segment.connections:
		weight += calculate_weight(connection)
	segment.weight = weight
	return weight

func calculate_connected_positions(segment: Segment):
	for room in segment.connections:
		var ratio = float(room.weight) / segment.weight
		room.position = segment.position + Vector2i(
			
		)

func render_tilemap(rooms: Array[Segment]):
	for x in range(map_width):
		for y in range(map_height):
			set_cell(LAYER, Vector2i(x, y), TILESET_SOURCE, BLACK)
	for room in rooms:
		var start = room.position - (room.size / 2)
		for x in range(room.size.x):
			for y in range(room.size.y):
				set_cell(LAYER, Vector2i(start.x + x, start.y + y), TILESET_SOURCE, WHITE)
	
	
