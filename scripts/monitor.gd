extends StaticBody3D

@export var seat: Marker3D
@export var screen: Node3D

func interact() -> void:
	if seat == null or screen == null:
		push_error("Monitor " + name + " is missing its Seat or Screen!")
		return
	var player = get_tree().get_first_node_in_group("player")
	await player.sit_at(seat, screen)
	screen.open()
