extends TileMap

@export var map_width: int = 71
@export var map_height: int = 40
@export var seed: int = 964502
@export var blue_fill: float = 0.5
@export var green_fill: float = 0.8
@export var room_count: int = 5

var cell_iterations = 0
var rng: RandomNumberGenerator
var map_graph: MapGraph
var cellular_automata: CellularAutomata
var grid_rooms: GridRooms

const LAYER = 0
const DEBUG_TILESET_SOURCE = 0
const BLACK: Vector2i = Vector2i(0, 0)
const WHITE: Vector2i = Vector2i(1, 0)
const BLUE: Vector2i = Vector2i(0, 1)
const GREEN: Vector2i = Vector2i(1, 1)

const TILESET_SOURCE = 1
const TOP_LEFT_CORNER: Vector2i = Vector2i(0, 0)
const TOP_EDGE: Vector2i = Vector2i(1, 0)
const TOP_RIGHT_CORNER: Vector2i = Vector2i(2, 0)
const EMPTY: Vector2i = Vector2i(3, 0)
const LEFT_EDGE: Vector2i = Vector2i(0, 1)
const CENTER: Vector2i = Vector2i(1, 1)
const RIGHT_EDGE: Vector2i = Vector2i(2, 1)
const TWIN_LEFT_RIGHT: Vector2i = Vector2i(3, 1)
const BOTTOM_LEFT_CORNER: Vector2i = Vector2i(0, 2)
const BOTTOM_EDGE: Vector2i = Vector2i(1, 2)
const BOTTOM_RIGHT_CORNER: Vector2i = Vector2i(2, 2)
const TWIN_RIGHT_LEFT: Vector2i = Vector2i(3, 2)
const GAP_BOTTOM_RIGHT: Vector2i = Vector2i(0, 3)
const GAP_BOTTOM_LEFT: Vector2i = Vector2i(1, 3)
const GAP_TOP_RIGHT: Vector2i = Vector2i(2, 3)
const GAP_TOP_LEFT: Vector2i = Vector2i(3, 3)

const NEIGHBORS: Array[Vector2i] = [
	Vector2i(0, 0), # Top left
	Vector2i(1, 0), # Top right
	Vector2i(0, 1), # Bottom left
	Vector2i(1, 1), # Bottom right
]

const TILE_DICT: Dictionary = {
	"0000": EMPTY,
	"0001": TOP_LEFT_CORNER,
	"0010": TOP_RIGHT_CORNER,
	"0100": BOTTOM_LEFT_CORNER,
	"1000": BOTTOM_RIGHT_CORNER,
	"0101": TWIN_RIGHT_LEFT,
	"1010": TWIN_LEFT_RIGHT,
	"0011": TOP_EDGE,
	"1100": BOTTOM_EDGE,
	"0111": GAP_TOP_LEFT,
	"1011": GAP_TOP_RIGHT,
	"1101": GAP_BOTTOM_LEFT,
	"1110": GAP_BOTTOM_RIGHT,
	"1111": CENTER
}

func _ready():
	draw_map()

func _input(event):
	if event is InputEventKey and event.pressed:
		cell_iterations = int(event.as_text())
		draw_map()
		
func draw_map():
	rng = RandomNumberGenerator.new()
	rng.seed = seed
	#var newSeed = rng.randi_range(1,1000000)
	#rng.seed = newSeed
	#print("Seed: " + str(newSeed))
	cellular_automata = CellularAutomata.new()
	cellular_automata.init(rng, Vector2i(map_width, map_height))
	grid_rooms = GridRooms.new()
	grid_rooms.init(rng, Vector2i(map_width, map_height))
	grid_rooms.generate_map()
	render_tilemap()

func render_tilemap():
	cellular_automata.cells = grid_rooms.get_global_grid()
	cellular_automata.iterate(6)
	for x in range(map_width):
		for y in range(map_height):
			set_cell(LAYER, Vector2i(x, y), TILESET_SOURCE, 
				get_tile(x, y, cellular_automata.cells))

func get_tile(x: int, y: int, map: Array) -> Vector2i:
	# Map Border
	if x == 0 or x == map_width-1 or y == 0 or y == map_height-1:
		return CENTER
	var key = ""
	# Top left
	key += "1" if map[x][y] else "0"
	# Top right
	key += "1" if map[x+1][y] else "0"
	# Bottom left
	key += "1" if map[x][y+1] else "0"
	# Bottom right
	key += "1" if map[x+1][y+1] else "0"
	
	return TILE_DICT[key]

func render_tilemap_black_and_white():
	cellular_automata.cells = grid_rooms.get_global_grid()
	#cellular_automata.cells = get_array_from_tilemap()
	cellular_automata.iterate(cell_iterations)
	for x in range(map_width):
		for y in range(map_height):
			set_cell(LAYER, Vector2i(x, y), DEBUG_TILESET_SOURCE, 
			WHITE if cellular_automata.cells[x][y] else BLACK)

func get_array_from_grid_graph() -> Array[Array]:
	var map: Array[Array] = []
	for x in range(map_width):
		var row = []
		for y in range(map_height):
			var val = grid_rooms.get_global_coord_tile(x, y)
			row.append(val)
		map.append(row)
	return map

func get_array_from_tilemap() -> Array[Array]:
	var map: Array[Array] = []
	for x in range(map_width):
		var row = []
		for y in range(map_height):
			var val = false
			match get_cell_atlas_coords(LAYER, Vector2i(x, y)):
				WHITE:
					val = true
				BLUE:
					val = rng.randf() < blue_fill
				GREEN:
					val = rng.randf() < green_fill
				_:
					val = false
			row.append(val)
		map.append(row)
	return map
