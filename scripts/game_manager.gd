extends Node

# Subheading: Global Game States
var player_inventory: Dictionary = {}
var is_game_paused: bool = false

# Subheading: Initializer
func _ready() -> void:
	# Initialize basic game state parameters
	process_mode = PROCESS_MODE_ALWAYS

# Subheading: Inventory Management Functions
func add_item_to_inventory(item_name: String, amount: int) -> void:
	if player_inventory.has(item_name):
		player_inventory[item_name] += amount
	else:
		player_inventory[item_name] = amount

func remove_item_from_inventory(item_name: String, amount: int) -> bool:
	if player_inventory.has(item_name) and player_inventory[item_name] >= amount:
		player_inventory[item_name] -= amount
		if player_inventory[item_name] == 0:
			player_inventory.erase(item_name)
		return true
	return false

