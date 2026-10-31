extends CharacterBody3D

@export var speed: float = 3.0
@export var gravity: float = 9.8
@export var mouse_sensitivity: float = 0.002 # radians per pixel
@export var max_pitch_degrees: float = 89.0 # highest player can look up

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity) # yaw turns the whole body
		camera.rotate_x(-event.relative.y * mouse_sensitivity) # pitch only tilts the camera
		var max_pitch := deg_to_rad(max_pitch_degrees)
		camera.rotation.x = clamp(camera.rotation.x, -max_pitch, max_pitch)
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # Esc frees the cursor
	elif event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # click to recapture

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta # gravity in air
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)
	var direction := transform.basis * Vector3(
		input_direction.x,
		0.0,
		input_direction.y
	)
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()
