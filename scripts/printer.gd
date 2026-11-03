extends StaticBody3D

var is_busy := false

func interact() -> void:
	if is_busy:
		return
	var ticket = TicketManager.get_open_ticket("Printer")
	if ticket != null:
		is_busy = true
		print("Working on: ", ticket.title)
		await get_tree().create_timer(3.0).timeout
		if ticket.haunted:
			print("SCARRRYYYY")
		else:
			print("Fixed")
		ticket.resolved = true
		is_busy = false
	else:
		print("No open tickets for the printer.")
