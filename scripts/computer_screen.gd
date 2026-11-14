extends Node3D

@export var cursor_speed: float = 0.6

@onready var viewport: SubViewport = $SubViewport
@onready var screen_mesh: MeshInstance3D = $ScreenMesh
@onready var cursor: Control = $SubViewport/Cursor

var active := false
var cursor_pos := Vector2.ZERO

func _ready() -> void:
	add_to_group("computer_screen")
	var material: StandardMaterial3D = screen_mesh.get_surface_override_material(0)
	material.albedo_texture = viewport.get_texture()
	cursor.visible = false

func activate() -> void:
	active = true
	cursor_pos = Vector2(viewport.size) / 2
	cursor.visible = true
	move_cursor(Vector2.ZERO)

func deactivate() -> void:
	active = false
	cursor.visible = false

func _input(event: InputEvent) -> void:
	if not active:
		return
	if event is InputEventMouseMotion:
		move_cursor(event.relative * cursor_speed)
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton:
		var click: InputEventMouseButton = event.duplicate()
		click.position = cursor_pos
		click.global_position = cursor_pos
		viewport.push_input(click)
		get_viewport().set_input_as_handled()

func move_cursor(amount: Vector2) -> void:
	cursor_pos += amount
	cursor_pos = cursor_pos.clamp(Vector2.ZERO, Vector2(viewport.size))
	cursor.position = cursor_pos
	var motion := InputEventMouseMotion.new()
	motion.position = cursor_pos
	motion.global_position = cursor_pos
	viewport.push_input(motion)
