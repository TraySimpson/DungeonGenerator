class_name GridRooms
extends RefCounted


@export var tiles_per_cell: int = 10
var map_grid_size: Vector2i
var grid: Array[Array] = []


func init(mapSize: Vector2i) -> void:
	map_grid_size = mapSize / tiles_per_cell
	grid = get_clear_grid()

func get_clear_grid() -> Array[Array]:
	var clear_grid = []
	for x in range(map_grid_size.x):
		var row = []
		for y in range(map_grid_size.y):
			var cell = GridCell.new()
			cell.type = CellType.Empty
			cell.coordinates = Vector2i(x, y)
			cell.connections = []
			row.append(cell)
		clear_grid.append(row)
	return clear_grid
