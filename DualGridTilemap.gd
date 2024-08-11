class_name DualGridTilemap
extends TileMap


@export var grass_placeholder_atlas_coords: Vector2i
@export var dirt_placeholder_atlas_coords: Vector2i
const MAIN_LAYER = 0
const DISPLAY_LAYER = 1
const NEIGHBORS: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(1, 1)
]

enum TileType { None, Grass, Dirt }

const NEIGHBORS_TO_COORDS: Dictionary = {
	{TileType.Grass, TileType.Grass, TileType.Grass, TileType.Grass}: Vector2i(2, 1), // All corners
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(2, 1), // All corners
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(2, 1) // All corners
}
#
#{new (Grass, Grass, Grass, Grass), new Vector2I(2, 1)}, // All corners
		#{new (Dirt, Dirt, Dirt, Grass), new Vector2I(1, 3)}, // Outer bottom-right corner
		#{new (Dirt, Dirt, Grass, Dirt), new Vector2I(0, 0)}, // Outer bottom-left corner
		#{new (Dirt, Grass, Dirt, Dirt), new Vector2I(0, 2)}, // Outer top-right corner
		#{new (Grass, Dirt, Dirt, Dirt), new Vector2I(3, 3)}, // Outer top-left corner
		#{new (Dirt, Grass, Dirt, Grass), new Vector2I(1, 0)}, // Right edge
		#{new (Grass, Dirt, Grass, Dirt), new Vector2I(3, 2)}, // Left edge
		#{new (Dirt, Dirt, Grass, Grass), new Vector2I(3, 0)}, // Bottom edge
		#{new (Grass, Grass, Dirt, Dirt), new Vector2I(1, 2)}, // Top edge
		#{new (Dirt, Grass, Grass, Grass), new Vector2I(1, 1)}, // Inner bottom-right corner
		#{new (Grass, Dirt, Grass, Grass), new Vector2I(2, 0)}, // Inner bottom-left corner
		#{new (Grass, Grass, Dirt, Grass), new Vector2I(2, 2)}, // Inner top-right corner
		#{new (Grass, Grass, Grass, Dirt), new Vector2I(3, 1)}, // Inner top-left corner
		#{new (Dirt, Grass, Grass, Dirt), new Vector2I(2, 3)}, // Bottom-left top-right corners
		#{new (Grass, Dirt, Dirt, Grass), new Vector2I(0, 1)}, // Top-left down-right corners
		#{new (Dirt, Dirt, Dirt, Dirt), new Vector2I(0, 3)}, // No corners

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
