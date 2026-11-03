extends Control

@onready var ticket_list: ItemList = %TicketList
@onready var details: RichTextLabel = %Details
var shown_tickets:Array[Ticket] = []

func _ready() -> void:
	for ticket in TicketManager.tickets:
		if not ticket.resolved:
			ticket_list.add_item("#" + str(ticket.ticket_number) + "  " + ticket.title)
			shown_tickets.append(ticket)


func _on_ticket_list_item_selected(index: int) -> void:
	var ticket = shown_tickets[index]
	details.text = "#" + str(ticket.ticket_number) + " " + ticket.title + "\n" + "From: " + ticket.submitted_by + "\n" + ticket.submitted_date + " " + ticket.submitted_time + "\n" + ticket.description
