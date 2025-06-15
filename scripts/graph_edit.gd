extends GraphEdit
var selected_nodes = {}
#@export_range(0.0, 1.0, 0.1) var amount: float

func _input(event: InputEvent) -> void:
	if event is InputEvent:
		if event.is_action_pressed("ui_graph_delete"):
			for node in selected_nodes.keys():
				# First remove all connections
				if selected_nodes[node]:
					for connectionInfo in connections:
						if connectionInfo.from_node == node.name or connectionInfo.to_node == node.name:
							disconnect_node(connectionInfo.from_node, connectionInfo.from_port, connectionInfo.to_node, connectionInfo.to_port)
					node.queue_free()
			print("deleted")
			selected_nodes = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom = 0.80
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#for con in connections:
	#	set_connection_activity(con.from_node, con.from_port, con.to_node, con.to_port, amount)


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_add_sub_node_pressed() -> void:
	pass # Replace with function body.


func _on_node_selected(node: Node) -> void:
	selected_nodes[node] = true


func _on_node_deselected(node: Node) -> void:
	selected_nodes[node] = false


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	print("node delete")

func clear_graph() -> void:
	for node in get_children():
	# First remove all connections
		if node is GraphNode:
			for connectionInfo in connections:
				if connectionInfo.from_node == node.name or connectionInfo.to_node == node.name:
					disconnect_node(connectionInfo.from_node, connectionInfo.from_port, connectionInfo.to_node, connectionInfo.to_port)
			node.queue_free()
	print("deleted all node")


func _on_control_2d_clear_graph() -> void:
	clear_graph()
