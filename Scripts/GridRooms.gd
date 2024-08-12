class_name GridRooms
extends RefCounted


@export var tiles_per_cell: int = 10
@export var target_depth: int = 5
@export var max_room_connections: int = 3
var map_grid_size: Vector2i
var rng: RandomNumberGenerator
var grid: Array[Array] = []
var processing_rooms: Array[GridCell] = []


func init(generator: RandomNumberGenerator, mapSize: Vector2i) -> void:
	map_grid_size = mapSize / tiles_per_cell
	rng = generator
	grid = get_clear_grid()

func get_clear_grid() -> Array[Array]:
	var clear_grid: Array[Array] = []
	for x in range(map_grid_size.x):
		var row = []
		for y in range(map_grid_size.y):
			var cell = GridCell.new()
			cell.type = CellType.Empty
			cell.coordinates = Vector2i(x, y)
			row.append(cell)
		clear_grid.append(row)
	return clear_grid

func generate_map() -> void:
	var root: GridCell = grid[map_grid_size.x / 2][map_grid_size.y - 1]
	root.type = CellType.Room
	root.depth = 1
	processing_rooms = [root]
	while not processing_rooms.is_empty() and should_add_more_rooms():
		add_connections()

func add_connections() -> void:
	var cell: GridCell = processing_rooms.pop_front()
	var open_spaces = get_empty_neighbors(cell)
	if open_spaces.is_empty():
		return
	var connection_count = get_connection_count(open_spaces.size())
	for i in range(connection_count):
		var new_room: GridCell = open_spaces.pop_at(
			rng.randi_range(0, open_spaces.size() - 1)
		)
		cell.connections.append(new_room)
		new_room.connections.append(cell)
		new_room.depth = cell.depth + 1
		new_room.type = CellType.Room
		processing_rooms.append(new_room)

func should_add_more_rooms() -> bool:
	var has_empty: bool = false
	for x in range(map_grid_size.x):
		for y in range(map_grid_size.y):
			var tile: GridCell = grid[x][y]
			if tile.depth == target_depth:
				return false
			elif tile.type == CellType.Empty:
				has_empty = true
	return has_empty
	
func get_empty_neighbors(cell: GridCell) -> Array[GridCell]:
	var neighbors: Array[GridCell] = []
	for x in range(cell.coordinates.x - 1, cell.coordinates.x + 2):
		for y in range(cell.coordinates.y - 1, cell.coordinates.y + 2):
			if (x >= 0 and x < map_grid_size.x and y >= 0 and y < map_grid_size.y):
				if (grid[x][y] != cell):
					neighbors.append(grid[x][y])
	return neighbors

func get_connection_count(max_connections: int) -> int:
	if max_connections > max_room_connections:
		max_connections = max_room_connections
	return rng.randi_range(1, max_connections)
	
func get_global_coord_tile(x: int, y: int) -> bool:
	return grid[x / tiles_per_cell][y / tiles_per_cell].type != CellType.Empty
