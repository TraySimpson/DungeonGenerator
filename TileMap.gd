extends TileMap

@export var map_width: int = 71
@export var map_height: int = 40
var cell_iterations = 1

const LAYER = 0
const TILESET_SOURCE = 0
const BLACK: Vector2i = Vector2i(0, 0)
const WHITE: Vector2i = Vector2i(1, 0)
const BLUE: Vector2i = Vector2i(0, 1)
const GREEN: Vector2i = Vector2i(1, 1)


func _ready():
	draw_map()

func _input(event):
	if event is InputEventKey and event.pressed:
		print("Hit " + str(int(event.as_text())))
		cell_iterations = int(event.as_text())
		draw_map()
		
func draw_map():
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
	room.size = Vector2i(4, 4)
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
	connectionZone.size = Vector2i(20, 20)
	connectionZone.position = Vector2i(32, 27)
	var start = connectionZone.position - (connectionZone.size / 2)
	var cells = cellular_automata(connectionZone.size, cell_iterations)
	for x in range(connectionZone.size.x):
			for y in range(connectionZone.size.y):
				set_cell(LAYER, Vector2i(start.x + x, start.y + y), TILESET_SOURCE, 
				BLUE if cells[x][y] else GREEN)

func cellular_automata(size: Vector2i, iterations: int) -> Array[Array]:
	var cells = get_array(size, 0.5)
	for i in iterations:
		var newCells = get_array(size, 0.0)
		for x in range(size.x):
			for y in range(size.y):
				var wallCount = get_surrounding_wall_count(x, y, cells)
				if (wallCount > 4):
					newCells[x][y] = true
				elif (wallCount < 4):
					newCells[x][y] = false
				else:
					newCells[x][y] = cells[x][y]
		cells = newCells
	return cells

func get_array(size: Vector2i, fill_change: float) -> Array[Array]:
	var cells: Array[Array] = []
	var count = 0
	for x in range(size.x):
		var rows = []
		for y in range(size.y):
			var val = randf() > fill_change
			if (val):
				count += 1
			rows.append(val)
		cells.append(rows)
	print("Fill: " + str(fill_change) + "   " + str(count) + "/" + str(size.x * size.y))
	return cells
	
	
func get_surrounding_wall_count(targetX: int, targetY: int, map: Array[Array]) -> int:
	var count = 0
	for x in range(targetX - 1, targetX + 1):
		for y in range(targetY - 1, targetY + 1):
			if (x >= 0 and x < map.size() and y >= 0 and y < map[x].size()):
				count += 1 if map[x][y] else 0
			else:
				count += 1
	return count
