extends CharacterBody3D

@export var speed: float = 3.0
@export var gravity: float = 9.8
	
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
