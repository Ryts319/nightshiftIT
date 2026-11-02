extends Node

@export var tickets: Array[Ticket] = [
	preload("res://tickets/ticket1.tres"),
	preload("res://tickets/ticket2.tres"),
	preload("res://tickets/ticket3.tres"),
]	

func _ready() -> void:
	for ticket in tickets:
		# if this tickets target matches target_name, and it's not resolved, return it
		print(ticket.title)
		
func get_open_ticket(target_name: String) -> Ticket:
	for ticket in tickets:
		if ticket.target == target_name and not ticket.resolved:
			return ticket
	return null
