extends HBoxContainer

@export var canvas: CanvasLayer


func _on_red_button_pressed() -> void:
	canvas.change_colour.emit(Color.RED)


func _on_blue_button_pressed() -> void:
	canvas.change_colour.emit(Color.BLUE)


func _on_green_button_pressed() -> void:
	canvas.change_colour.emit(Color.LIME)


func _on_white_button_pressed() -> void:
	canvas.change_colour.emit(Color.WHITE)
