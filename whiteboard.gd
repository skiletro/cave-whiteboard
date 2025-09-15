extends CanvasLayer

signal change_colour(new_colour: Color)

var positions: Dictionary = {}
var color: Color = Color.WHITE

@export var dock_rect: Control
@export var color_preview: ColorRect

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()

	if event.is_action_pressed("clear"):
		_on_clear_button_pressed()

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

	if event is InputEventScreenTouch:
		if event.pressed:
			var new_line: Line2D = Line2D.new()
			new_line.default_color = color
			new_line.width = 25.0
			new_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
			new_line.end_cap_mode = Line2D.LINE_CAP_ROUND
			new_line.joint_mode = Line2D.LINE_JOINT_ROUND
			add_child(new_line)
			positions[event.index] = {pos = event.position, line = new_line, is_active = true}

		else:
			positions.erase(event.index)
		get_viewport().set_input_as_handled()

	if event is InputEventScreenDrag:
		if !positions.has(event.index):
			return
			
		positions[event.index]["pos"] = event.position
		get_viewport().set_input_as_handled()


func _physics_process(delta: float) -> void:
	for index in positions:
		if dock_rect.get_rect().has_point(positions[index]["pos"]):
			positions[index]["is_active"] = false

		if positions[index]["is_active"]:
			#print(positions[index]["line"].get_point_position(0).distance_to(positions[index]["pos"]))
			var count: int = positions[index]["line"].get_point_count() - 1
			var last_pos = positions[index]["line"].get_point_position(count)
			var current_pos = positions[index]["pos"]
			
			if last_pos.distance_to(current_pos) >= 3:
				positions[index]["line"].add_point(positions[index]["pos"])
				


func _on_change_colour(new_colour: Color) -> void:
	color = new_colour

func _on_clear_button_pressed() -> void:
		for node in self.get_children():
			if node is Line2D:
				node.queue_free()
