extends PanelContainer

var state = {}
var lines = {}


func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()

	if event.is_action_pressed("clear"):
		for node in self.get_children():
			if node is Line2D:
				node.queue_free()

	if event.is_action_pressed("fullscreen"):
		var mode := DisplayServer.window_get_mode()
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(
			(
				DisplayServer.WINDOW_MODE_FULLSCREEN
				if is_window
				else DisplayServer.WINDOW_MODE_WINDOWED
			)
		)

	elif event is InputEventScreenTouch:
		if event.pressed:  # Down.
			state[event.index] = event.position
			lines[event.index] = Line2D.new()
			lines[event.index].width = 25.0
			lines[event.index].begin_cap_mode = Line2D.LINE_CAP_ROUND
			lines[event.index].end_cap_mode = Line2D.LINE_CAP_ROUND
			lines[event.index].joint_mode = Line2D.LINE_JOINT_ROUND
			lines[event.index].default_color = _get_color_for_ptr_index(event.index)
			lines[event.index].add_point(event.position + Vector2(-0.001, 0.001))
			lines[event.index].add_point(event.position + Vector2(0.001, -0.001))
			add_child(lines[event.index])
		else:  # Up.
			state.erase(event.index)
		get_viewport().set_input_as_handled()

	elif event is InputEventScreenDrag:  # Movement.
		state[event.index] = event.position
		lines[event.index].add_point(event.position)
		get_viewport().set_input_as_handled()


func _get_color_for_ptr_index(index) -> Color:
	var x = (index % 7) + 1
	return Color(float(bool(x & 1)), float(bool(x & 2)), float(bool(x & 4)))
