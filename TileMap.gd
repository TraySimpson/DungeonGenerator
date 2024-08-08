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
	var room = Segment.new()
	room.size = Vector2i(3, 3)
	room.position = Vector2i(map_width / 2 - 1, map_height - 2)
	return [ room ]

func render_tilemap(rooms: Array[Segment]):
	for x in range(map_width):
		for y in range(map_height):
			set_cell(LAYER, Vector2i(x, y), TILESET_SOURCE, BLACK)
	for room in rooms:
		var start = room.position - (room.size / 2)
		for x in range(room.size.x):
			for y in range(room.size.y):
				set_cell(LAYER, Vector2i(start.x + x, start.y + y), TILESET_SOURCE, WHITE)
	
	
