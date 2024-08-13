class_name GridRooms
extends RefCounted


@export var max_room_dimension: int = 15
@export var min_room_dimension: int = 6
@export var hallway_thickness: int = 2
@export var tiles_per_cell: int = 20
@export var target_depth: int = 10
@export var max_room_connections: int = 4
@export var min_room_connections: int = 1
@export var background_fill = .0
@export var hallway_fill = 1.0
@export var room_fill = 1.0
var global_grid_size: Vector2i
var map_grid_size: Vector2i
var rng: RandomNumberGenerator
var grid: Array[Array] = []
var processing_rooms: Array[GridCell] = []


func init(generator: RandomNumberGenerator, mapSize: Vector2i) -> void:
	global_grid_size = mapSize
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
	var lastNode = root
	for i in range(target_depth - 1):
		if not grid_is_full():
			var neighbors = get_empty_neighbors(lastNode)
			var node: GridCell = neighbors[rng.randi_range(0, neighbors.size() - 1)]
			node.type = CellType.Room
			node.depth = lastNode.depth + 1
			node.connections.append(lastNode)
			lastNode.connections.append(node)
			lastNode = node
	#processing_rooms = [root]
	#while not processing_rooms.is_empty() and should_add_more_rooms():
		#add_connections()

func grid_is_full() -> bool:
	for x in range(map_grid_size.x):
		for y in range(map_grid_size.y):
			var tile: GridCell = grid[x][y]
			if tile.type == CellType.Empty:
				return false
	return true

func add_connections() -> void:
	var cell: GridCell = processing_rooms.pop_front()
	var open_spaces = get_empty_neighbors(cell)
	if open_spaces.is_empty():
		return
	var connection_count = get_connection_count(open_spaces.size(), cell.depth) - cell.connections.size()
	if (connection_count < 0):
		connection_count = 0
	print("Creating room with " + str(connection_count) + " connections")
	for i in range(connection_count):
		var new_room: GridCell = open_spaces.pop_at(
			rng.randi_range(0, open_spaces.size() - 1)
		)
		cell.connections.append(new_room)
		new_room.connections.append(cell)
		new_room.depth = cell.depth + 1
		new_room.type = CellType.Room
		processing_rooms.append(new_room)

	
func get_empty_neighbors(cell: GridCell) -> Array[GridCell]:
	var neighbors: Array[GridCell] = []
	for x in range(cell.coordinates.x - 1, cell.coordinates.x + 2):
		for y in range(cell.coordinates.y - 1, cell.coordinates.y + 2):
			if (x >= 0 and x < map_grid_size.x and y >= 0 and y < map_grid_size.y):
				if (grid[x][y] != cell and grid[x][y].type == CellType.Empty and (x == cell.coordinates.x or y == cell.coordinates.y)):
					neighbors.append(grid[x][y])
	return neighbors

func get_connection_count(max_connections: int, depth: int) -> int:
	if max_connections > max_room_connections:
		max_connections = max_room_connections
	var min_connections = min_room_connections if depth >= (target_depth / 2) + 1 else min_room_connections + 2
	return rng.randi_range(min_room_connections, max_connections)
	
func get_global_coord_tile(x: int, y: int) -> bool:
	return grid[x / tiles_per_cell][y / tiles_per_cell].type != CellType.Empty

func get_global_grid() -> Array[Array]:
	var global_grid: Array[Array] = []
	for x in global_grid_size.x:
		var row = []
		for y in global_grid_size.y:
			row.append(rng.randf() < background_fill)
		global_grid.append(row)
	for x in map_grid_size.x:
		for y in map_grid_size.y:
			if (grid[x][y].type != CellType.Empty):
				draw_room(global_grid, grid[x][y])
				draw_connections(global_grid, grid[x][y])
	return global_grid

func draw_room(map, cell: GridCell) -> void:
	var width = rng.randi_range(min_room_dimension, max_room_dimension + 1)
	var height = rng.randi_range(min_room_dimension, max_room_dimension + 1)
	var x_offset = rng.randi_range(0, tiles_per_cell - (2 + width))
	var y_offset = rng.randi_range(0, tiles_per_cell - (2 + height))
	var position = cell.coordinates * tiles_per_cell + Vector2i(x_offset, y_offset)
	for x in range(width):
		for y in range(height):
			map[x + position.x][y + position.y] = rng.randf() < room_fill

func draw_connections(map, cell: GridCell) -> void:
	for hall in cell.connections:
		var thickness = hallway_thickness
		var direction = cell.coordinates - hall.coordinates
		var start = Vector2i(0,0)
		var size = Vector2i(0,0)
		var hall_length = ceili(float(tiles_per_cell) / 2)
		match direction:
			Vector2i(0, 1): # Connection above
				start = cell.coordinates * tiles_per_cell + Vector2i(tiles_per_cell / 2, 0)
				size = Vector2i(thickness, hall_length)
			Vector2i(0, -1): # Connection below
				start = cell.coordinates * tiles_per_cell + Vector2i(tiles_per_cell / 2, tiles_per_cell / 2)
				size = Vector2i(thickness, hall_length)
			Vector2i(1, 0): # Connection to left
				start = cell.coordinates * tiles_per_cell + Vector2i(0, tiles_per_cell / 2)
				size = Vector2i(hall_length, thickness)
			Vector2i(-1, 0): # Connction to right
				start = cell.coordinates * tiles_per_cell + Vector2i(tiles_per_cell / 2, tiles_per_cell / 2)
				size = Vector2i(hall_length, thickness)
			_:
				printerr("Drawing connection on diagonal: " + str(direction))
		for x in range(size.x):
			for y in range(size.y):
				map[start.x + x][start.y + y] = rng.randf() < hallway_fill
