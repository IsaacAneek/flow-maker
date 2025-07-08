@tool
extends LineEdit
@export var on_hover_color: Color = Color("8b722e")
@export var default_color: Color = Color("ffffff")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	modulate = on_hover_color
	await get_tree().create_timer(0.3).timeout
	modulate = default_color

func _on_mouse_exited() -> void:
	modulate = default_color
