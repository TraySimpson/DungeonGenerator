class_name CellularAutomata
extends RefCounted

var size: Vector2i
var cells: Array = []
var rng: RandomNumberGenerator

func init(generator: RandomNumberGenerator, mapSize: Vector2i):
	size = mapSize
	rng = generator

func random_fill_cells(fill: float, includeBorders: bool = true) -> void:
	cells = get_array(size, fill, includeBorders)

func iterate(iterations: int) -> void:
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

func get_array(size: Vector2i, fill_change: float, include_borders: bool = false) -> Array[Array]:
	var cells: Array[Array] = []
	for x in range(size.x):
		var rows = []
		for y in range(size.y):
			var val = false
			if (include_borders and (x == 0 or x == size.x - 1 or y == 0 or y == size.y - 1)):
				val = false
			else:
				val = rng.randf() > fill_change
			rows.append(val)
		cells.append(rows)
	return cells
	
	
func get_surrounding_wall_count(targetX: int, targetY: int, map: Array[Array]) -> int:
	var count = 0
	for x in range(targetX - 1, targetX + 2):
		for y in range(targetY - 1, targetY + 2):
			if (x >= 0 and x < map.size() and y >= 0 and y < map[x].size() and not (x == targetX and y == targetY)):
				count += (1 if map[x][y] else 0)
	return count
