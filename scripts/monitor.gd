extends StaticBody3D

@export var seat: Marker3D

func interact() -> void:
	var player = get_tree().get_first_node_in_group("player")
	await player.sit_at(seat)
	get_tree().get_first_node_in_group("ticket_screen").open()
