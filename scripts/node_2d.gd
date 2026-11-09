extends Node2D

# Subheading: World Generation Settings
@export var map_width: int = 100
@export var map_height: int = 60
@export var dirt_level: int = 15
@export var stone_level: int = 30

# Subheading: References to Game Nodes
@onready var tile_map: TileMapLayer = $WorldTileMap

# Subheading: Noise Generator for Ore Distribution
var noise: FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	# Initialize noise settings for procedural generation
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.1
	
	generate_world()

# Subheading: Core Generation Logic
func generate_world() -> void:
	for x in range(map_width):
		for y in range(map_height):
			if y < dirt_level:
				continue
			elif y >= dirt_level and y < stone_level:
				# Surface: fill with dirt blocks (Atlas coords: 0, 0)
				tile_map.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			else:
				# Underground: generate stone and ores
				var noise_val = noise.get_noise_2d(x, y)
				if noise_val > 0.4:
					# Ore vein (Atlas coords: 2, 0)
					tile_map.set_cell(Vector2i(x, y), 0, Vector2i(2, 0))
				else:
					# Standard stone block (Atlas coords: 1, 0)
					tile_map.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))

# Subheading: Input Handling for Mining and Placing Blocks
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		# Convert global mouse position to local TileMap grid coordinates
		var global_mouse_pos = get_global_mouse_position()
		var click_cell = tile_map.local_to_map(tile_map.to_local(global_mouse_pos))
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Left Click: Mine / destroy a block by setting it to empty (-1)
			tile_map.set_cell(click_cell, -1)
			
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			# Right Click: Place a block if the clicked cell is currently empty
			var current_tile = tile_map.get_cell_source_id(click_cell)
			if current_tile == -1:
				# Place a dirt block (Atlas coords: 0, 0) from source 0
				tile_map.set_cell(click_cell, 0, Vector2i(0, 0))

