extends Node

@export var tickets: Array[Ticket] = [
preload("res://tickets/ticket1.tres"),
preload("res://tickets/ticket2.tres"),
preload("res://tickets/ticket3.tres"),
]	

func _ready() -> void:
	for ticket in tickets:
		print(ticket.title)
