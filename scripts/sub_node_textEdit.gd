extends TextEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	modulate = Color("7d7d7d")
	await get_tree().create_timer(0.3).timeout
	modulate = Color("ffffff")

func _on_mouse_exited() -> void:
	modulate = Color("ffffff")
