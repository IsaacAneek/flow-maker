extends GraphNode
@export var duplicated_graph_node: Control
@export var initial_pos_offset = Vector2(20.0, 20.0)
@export var SlotCount = 2

# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event is InputEvent:
		if has_focus():
			if event.is_action_pressed("ui_copy"):
					duplicated_graph_node = duplicate()
					print("copy")
			elif event.is_action_pressed("ui_paste"):
				if duplicated_graph_node:
					get_parent().add_child(duplicated_graph_node)
					duplicated_graph_node.position_offset += initial_pos_offset
					release_focus()
					selected = false
					duplicated_graph_node.grab_focus()
					duplicated_graph_node.selected = true
					#duplicated_graph_node = duplicated_graph_node.duplicate()
					print("pressed")

func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_add_sub_node_button_pressed() -> void:
	add_child(get_child(-1).duplicate())
	SlotCount += 1
	set_slot(SlotCount - 1, true, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))


func _on_mouse_entered() -> void:
	modulate = Color("cbcbcb")


func _on_mouse_exited() -> void:
	modulate = Color("ffffff")
