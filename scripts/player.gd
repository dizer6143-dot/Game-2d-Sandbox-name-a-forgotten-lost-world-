extends CharacterBody2D

# Subheading: Movement Parameters
@export var speed: float = 200.0
@export var jump_velocity: float = -400.0

# Subheading: Environmental Physics
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Subheading: Camera Setup
var camera: Camera2D

func _ready() -> void:
	# Initialize and configure the camera programmatically
	camera = Camera2D.new()
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0
	add_child(camera)

func _physics_process(delta: float) -> void:
	# Add gravity if the player is currently in the air
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle the jump action
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction for horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		# Smooth deceleration when no movement keys are pressed
		velocity.x = move_toward(velocity.x, 0, speed)

	# Execute movement and handle collisions automatically
	move_and_slide()

