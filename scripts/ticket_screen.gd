extends Control

@onready var ticket_list: ItemList = %TicketList
@onready var details: RichTextLabel = %Details
var shown_tickets: Array[Ticket] = []

func _ready() -> void:
	add_to_group("ticket_screen")
	refresh()

func open() -> void:
	refresh()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().get_first_node_in_group("computer_screen").activate()

func close() -> void:
	get_tree().get_first_node_in_group("computer_screen").deactivate()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().get_first_node_in_group("player").stand_up()

func refresh() -> void:
	ticket_list.clear()
	shown_tickets.clear()
	details.text = ""
	for ticket in TicketManager.tickets:
		if not ticket.resolved:
			ticket_list.add_item("#" + str(ticket.ticket_number) + "  " + ticket.title)
			shown_tickets.append(ticket)

func _on_ticket_list_item_selected(index: int) -> void:
	var ticket = shown_tickets[index]
	details.text = "#" + str(ticket.ticket_number) + " " + ticket.title + "\n" + "From: " + ticket.submitted_by + "\n" + ticket.submitted_date + " " + ticket.submitted_time + "\n" + ticket.description

func _on_close_button_pressed() -> void:
	close()
