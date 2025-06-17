extends GraphNode
@export var duplicated_graph_node: GraphNode
@export var initial_pos_offset = Vector2(20.0, 20.0)
@export var SlotCount = 1
const SUBNODE_H_BOX_CONTAINER = preload("res://scenes/subnode_h_box_container.tscn")

# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event is InputEvent:
		if selected:
			if event.is_action_pressed("ui_copy"):
				# This sometimes gives the following error :
				# "E 0:00:05:560   graph_node.gd:12 @ _input(): Node not found: "@HBoxContainer@332/RemoveSubNodeButton" (relative to "GraphNode")."
				# Dont know why
				# Dont even know if I need to resiolve this
				duplicated_graph_node = duplicate()
				print("copy")
			elif event.is_action_pressed("ui_paste"):
				instantiate_duplicatead_node()
			elif event.is_action_pressed("ui_graph_duplicate"):
				duplicated_graph_node = duplicate()
				print("copy and paste")
				instantiate_duplicatead_node()

func instantiate_duplicatead_node() -> void:
	if duplicated_graph_node:
		get_parent().add_child(duplicated_graph_node)
		duplicated_graph_node.position_offset += initial_pos_offset
		release_focus()
		selected = false
		duplicated_graph_node.grab_focus()
		duplicated_graph_node.selected = true
		#duplicated_graph_node = duplicated_graph_node.duplicate()
		print("instantiated duplicated node")

func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_add_sub_node_button_pressed() -> void:
	add_child(SUBNODE_H_BOX_CONTAINER.instantiate())
	set_slot(SlotCount, true, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))
	SlotCount += 1


func _on_mouse_entered() -> void:
	modulate = Color("cbcbcb")


func _on_mouse_exited() -> void:
	modulate = Color("ffffff")
