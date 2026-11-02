extends StaticBody3D

func interact() -> void:
	var ticket = TicketManager.get_open_ticket("Monitor2")
	if ticket.target == "Monitor2":
		print(ticket.description)
	else:
		print("No open tickets for the Monitor2")
