extends CanvasLayer

var mouse_mode_before_pause: Input.MouseMode

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			resume()
		else:
			pause()
		get_viewport().set_input_as_handled()

func pause() -> void:
	mouse_mode_before_pause = Input.mouse_mode
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func resume() -> void:
	visible = false
	get_tree().paused = false
	Input.mouse_mode = mouse_mode_before_pause
	
func _on_resume_button_pressed() -> void:
	resume()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
