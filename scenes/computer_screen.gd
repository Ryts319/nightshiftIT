extends Node3D

@onready var viewport: SubViewport = $SubViewport
@onready var screen_mesh: MeshInstance3D = $ScreenMesh

func _ready() -> void:
	get_viewport().physics_object_picking = true
	var material: StandardMaterial3D = screen_mesh.get_surface_override_material(0)
	material.albedo_texture = viewport.get_texture()

func _on_screen_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if not event is InputEventMouse:
		return
	# where on the quad did the mouse hit? (0,0 = center of the quad)
	var local: Vector3 = screen_mesh.global_transform.affine_inverse() * event_position
	var quad_size: Vector2 = screen_mesh.mesh.size
	# turn that into 0–1 across the screen (0,0 = top-left)
	var uv := Vector2(local.x / quad_size.x + 0.5, -local.y / quad_size.y + 0.5)
	# turn 0–1 into pixels on the SubViewport
	var pixel := uv * Vector2(viewport.size)
	# hand the event to the SubViewport at that pixel
	var e: InputEventMouse = event.duplicate()
	e.position = pixel
	e.global_position = pixel
	viewport.push_input(e)
