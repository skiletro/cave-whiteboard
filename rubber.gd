extends Button

var is_toggled: bool

func _ready():
	toggled.connect(_on_toggled)
	
func _on_toggled(toggled_on: bool):
	if is_toggled == toggled_on:
		return
	else:
		is_toggled = !is_toggled
	
	if toggled_on:
		create_tween().tween_property(self, "position:y", position.y - 50, 0.2)
		$"../..".emit_signal("change_colour", 0x232323ff)
	else:
		create_tween().tween_property(self, "position:y", position.y + 50, 0.2)
