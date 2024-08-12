extends TileMap

@export var map_width: int = 71
@export var map_height: int = 40
@export var seed: int = 10059
@export var blue_fill: float = 0.5
@export var green_fill: float = 0.8
@export var room_count: int = 5

var cell_iterations = 0
var rng: RandomNumberGenerator
var map_graph: MapGraph
var cellular_automata: CellularAutomata
var grid_rooms: GridRooms

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
	rng = RandomNumberGenerator.new()
	rng.seed = seed
	cellular_automata = CellularAutomata.new()
	cellular_automata.init(rng, Vector2i(map_width, map_height))
	grid_rooms = GridRooms.new()
	grid_rooms.init(rng, Vector2i(map_width, map_height))
	grid_rooms.generate_map()
	render_tilemap()
	

func render_tilemap():
	cellular_automata.cells = grid_rooms.get_global_grid()
	#cellular_automata.cells = get_array_from_tilemap()
	cellular_automata.iterate(cell_iterations)
	for x in range(map_width):
		for y in range(map_height):
			set_cell(LAYER, Vector2i(x, y), TILESET_SOURCE, 
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
