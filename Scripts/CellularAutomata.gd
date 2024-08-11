class_name CellularAutomata
extends RefCounted


var rng: RandomNumberGenerator

func init(generator: RandomNumberGenerator):
	rng = generator

func get_cells(size: Vector2i, iterations: int, startFill: float) -> Array[Array]:
	var cells = get_array(size, startFill, true)
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

func get_array(size: Vector2i, fill_change: float, include_borders: bool = false) -> Array[Array]:
	var cells: Array[Array] = []
	var count = 0
	for x in range(size.x):
		var rows = []
		for y in range(size.y):
			var val = false
			if (include_borders and (x == 0 or x == size.x - 1 or y == 0 or y == size.y - 1)):
				val = false
			else:
				val = rng.randf() > fill_change
			if (val):
				count += 1
			rows.append(val)
		cells.append(rows)
	print("Fill: " + str(fill_change) + "   " + str(count) + "/" + str(size.x * size.y))
	return cells
	
	
func get_surrounding_wall_count(targetX: int, targetY: int, map: Array[Array]) -> int:
	var count = 0
	for x in range(targetX - 1, targetX + 2):
		for y in range(targetY - 1, targetY + 2):
			if (x >= 0 and x < map.size() and y >= 0 and y < map[x].size() and not (x == targetX and y == targetY)):
				count += (1 if map[x][y] else 0)
	return count
