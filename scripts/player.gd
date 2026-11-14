extends CharacterBody3D

@export var speed: float = 3.0
@export var gravity: float = 9.8
@export var mouse_sensitivity: float = 0.002 # radians per pixel
@export var max_pitch_degrees: float = 89.0 # highest player can look up
@export var crouch_speed: float = 1.5
@export var crouch_height: float = 0.0
@export var stand_height: float = 0.6
@export var is_crouching := false

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var prompt: Label = $HUD/InteractPrompt
@onready var crouch: CollisionShape3D = $CollisionShape3D
@onready var stand_prompt: Label = $HUD/StandPrompt
@onready var crosshair: Label = $HUD/Crosshair

var is_seated := false
var standing_camera_transform: Transform3D
var camera_tween: Tween
var current_screen: Node3D
var is_standing_up := false

func _ready() -> void:
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	standing_camera_transform = camera.transform

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and (not is_seated or is_standing_up):
		rotate_y(-event.relative.x * mouse_sensitivity) # yaw turns the whole body
		camera.rotate_x(-event.relative.y * mouse_sensitivity) # pitch only tilts the camera
		var max_pitch := deg_to_rad(max_pitch_degrees)
		camera.rotation.x = clamp(camera.rotation.x, -max_pitch, max_pitch)
	elif event.is_action_pressed("interact"):
		if is_seated:
			current_screen.close()
		else:
			var target = get_interact_target()
			if target != null:
				target.interact()
	elif event.is_action_pressed("crouch"):
		is_crouching = not is_crouching
	elif event is InputEventMouseButton and event.pressed and not is_seated:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # click to recapture
		
func sit_at(seat: Marker3D, screen: Node3D) -> void:
	if is_seated:
		return
	is_seated = true
	current_screen = screen
	if camera_tween:
		camera_tween.kill()
	camera_tween = create_tween()
	camera_tween.tween_property(camera, "global_transform", seat.global_transform, 0.6)
	await camera_tween.finished

func stand_up() -> void:
	if not is_seated:
		return
	if camera_tween:
		camera_tween.kill()
	is_standing_up = true

	# hand the view direction back to the body
	var cam_pos := camera.global_position
	var facing := camera.global_rotation
	rotation.y = facing.y                       # body turns to face where you're looking
	camera.rotation = Vector3(facing.x, 0, 0)   # camera keeps only the up/down tilt
	camera.global_position = cam_pos            # don't let the camera jump

	# glide only the position back to standing height
	camera_tween = create_tween()
	camera_tween.tween_property(camera, "position", standing_camera_transform.origin, 0.6)
	await camera_tween.finished

	is_standing_up = false
	is_seated = false
		
func get_interact_target():
	var target = raycast.get_collider()
	if target != null and target.has_method("interact"):
		return target
	return null

func _process(delta: float) -> void:
		prompt.visible = get_interact_target() != null and not is_seated
		crosshair.visible = not is_seated
		stand_prompt.visible = is_seated

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta # gravity in air
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		input_direction = Vector2.ZERO
	
	var direction := transform.basis * Vector3(
		input_direction.x,
		0.0,
		input_direction.y
	)
	var current_speed := crouch_speed if is_crouching else speed
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	
	var target_height := crouch_height if is_crouching else stand_height
	if not is_seated:
		camera.position.y = lerp(camera.position.y, target_height, 10.0 * delta)
	
	move_and_slide()
