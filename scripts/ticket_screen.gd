extends Control

@onready var ticket_list: ItemList = %TicketList
@onready var details: RichTextLabel = %Details
var shown_tickets: Array[Ticket] = []
var selected_ticket: Ticket = null

signal close_requested

func _ready() -> void:
	refresh()

func _on_close_button_pressed() -> void:
	close_requested.emit()

func refresh() -> void:
	ticket_list.clear()
	shown_tickets.clear()
	details.text = ""
	for ticket in TicketManager.tickets:
		if not ticket.resolved:
			var i := ticket_list.add_item("#" + str(ticket.ticket_number) + "  " + ticket.title)
			ticket_list.set_item_tooltip_enabled(i, false)
			shown_tickets.append(ticket)
	if selected_ticket in shown_tickets:
		var index := shown_tickets.find(selected_ticket)
		ticket_list.select(index)
		show_details(selected_ticket)
	else:
		selected_ticket = null
			
func _on_ticket_list_item_selected(index: int) -> void:
	selected_ticket = shown_tickets[index]
	show_details(selected_ticket)

func show_details(ticket: Ticket) -> void:
	details.text = "#" + str(ticket.ticket_number) + " " + ticket.title + "\n" + "From: " + ticket.submitted_by + "\n" + ticket.submitted_date + " " + ticket.submitted_time + "\n" + ticket.description
