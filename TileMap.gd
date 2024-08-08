extends TileMap

@export var map_width: int = 100
@export var map_height: int = 100

const LAYER = 0
const TILESET_SOURCE = 0
const BLACK: Vector2i = Vector2i(0, 0)
const WHITE: Vector2i = Vector2i(1, 0)

func _ready():
	for x in range(map_width):
		for y in range(map_height):
			var color = WHITE if getColor(x, y) else BLACK 
			set_cell(LAYER, Vector2i(x, y), TILESET_SOURCE, color)
			
func getColor(x, y) -> bool:
	return x % 10 == 0 or y % 10 == 0
	
	
