extends StaticBody3D

func interact() -> void:
	var ticket = TicketManager.get_open_ticket("Printer")
	if ticket.target == "Printer":
		print(ticket.description)
	else:
		print("No open tickets for the printer.")
