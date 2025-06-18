extends GraphEdit
@onready var menu_handler: Control = $".."
var selected_nodes = {}
const GRAPH_NODE = preload("res://scenes/graph_node.tscn")
const HEAD_NODE = preload("res://scenes/HEAD.tscn")
const SUBNODE_H_BOX_CONTAINER = preload("res://scenes/subnode_h_box_container.tscn")
@onready var save_file_dialog: FileDialog = $"../SaveFileDialog"
#@export_range(0.0, 1.0, 0.1) var amount: float

func _input(event: InputEvent) -> void:
	if event is InputEvent:
		if event.is_action_pressed("ui_graph_delete"):
			delete_selected_nodes()
		elif event.is_action_pressed("save_file"):
			if menu_handler.last_selected_path == "":
				save_file_dialog.visible = true
			else:
				save_graph_as_resource(menu_handler.last_selected_path)
		elif event.is_action_pressed("select_all"):
			select_all_nodes()

func delete_selected_nodes() -> void:
	for node in selected_nodes.keys():
		# Check if the node is in the selected list
		if selected_nodes[node]:
			# Remove connections first
			for connectionInfo in connections:
				if connectionInfo.from_node == node.name or connectionInfo.to_node == node.name:
					disconnect_node(connectionInfo.from_node, connectionInfo.from_port, connectionInfo.to_node, connectionInfo.to_port)
			node.queue_free()
	print("deleted these nodes")
	selected_nodes = {}

func select_all_nodes() -> void:
	for node in get_children():
		if node is GraphNode:
			node.selected = true

# MAKE THIS MORE REDABLE AND FRINDLY :<
func save_graph_as_resource(filename: String) -> void:
	var graph_data = GraphData.new()
	graph_data.connections = get_connection_list()
	for graphNode in get_children():
		if graphNode is GraphNode:
			var GRAPH_NODE_data = GraphNodeData.new()
			GRAPH_NODE_data.name = graphNode.name.validate_node_name()
			GRAPH_NODE_data.offset = graphNode.position_offset
			
			for subNode in graphNode.get_children():
				if subNode is HBoxContainer:
					var sub_node_data = SubNodeData.new()
					sub_node_data.topic = subNode.get_child(0).text
					GRAPH_NODE_data.subNodes.append(sub_node_data)
			graph_data.graphNodes.append(GRAPH_NODE_data)
	if ResourceSaver.save(graph_data, filename) == OK:
		print(filename)
		print("connections saved")
		print(graph_data.connections)
	else:
		print("save failed")

## Extract graph data from the given resource file
# WARNING : I/O bound function. Takes up a huge amount of frame time in low-end devices.
# Make this async?
func init_graph(Graph_Data: GraphData):
	for g_node_data in Graph_Data.graphNodes:
		var graph_node = GRAPH_NODE.instantiate() as GraphNode
		graph_node.position_offset = g_node_data.offset
		graph_node.name = g_node_data.name
		
		# Is this causing the problem??
		var slotIndex = 1
		for sub_node_data in g_node_data.subNodes:
			# Init first node as the HEAD node (TODO)
			var s_node = SUBNODE_H_BOX_CONTAINER.instantiate()
			s_node.get_child(0).text = sub_node_data.topic
			graph_node.set_slot(slotIndex, true, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))
			slotIndex += 1
			graph_node.add_child(s_node)
		
		add_child(graph_node)
		graph_node.name = g_node_data.name
		
		print("Graph Node name in scene :")
		print(graph_node.name)
		print("Actual name :")
		print(g_node_data.name)
		print("")
	
	print("all connections initiated from save file")
	for connection in Graph_Data.connections:
		print(connection)
		connect_node(connection.from_node, connection.from_port, connection.to_node, connection.to_port)
			

# Load the resource file
func load_graph_as_resource(filename: String) -> void:
	# call delete all node function
	# clear the graph first
	if ResourceLoader.exists(filename):
		var graph_data = ResourceLoader.load(filename)
		if graph_data is GraphData:
			init_graph(graph_data)
		else:
			# Error loading data
			print("File found but error loading data")
	else:
		# File not found
		print("File not found")

func create_head_node() -> void:
	var head = HEAD_NODE.instantiate() as GraphNode
	add_child(head)
	head.position_offset = Vector2(get_viewport_rect().size / 2)

func create_node() -> void:
	var gNode = GRAPH_NODE.instantiate() as GraphNode
	add_child(gNode)
	gNode.position_offset = Vector2(get_viewport_rect().size / 2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_node_selected(node: Node) -> void:
	selected_nodes[node] = true


func _on_node_deselected(node: Node) -> void:
	selected_nodes[node] = false


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	delete_selected_nodes()
	print("node delete")

## Instantly clears all nodes from the graph using Object.free().[br]
## [b]NOTE[/b] : It doesnt explicitely clear all the connections
## so you might need to call clear_connections() as well
func clear_graph() -> void:
	for node in get_children():
	# First remove all connections
		# UPDATE : OK this works with "New Graph" option but not 
		# with "Open Graph" option.... what...???
		# UPDATE : Ok so what i think is that since node.queue_free() doesnt
		# deletes the node immediately rather queues it at the end
		# of the frame to be deleted, the nodes that will be instantiated from
		# the save file get instantiated before the end of the frame.
		# So yeah the nodes get duplicated and their name gets changed
		# and so the connections become invalid.
		if node is GraphNode:
			print("Heh it is GraphNode B)")
			node.free()
			# Might cause runtime errors, needs to be kept observed
	print("deleted all node")

func duplicate_selected_nodes() -> void:
	for node in selected_nodes.keys():
		add_child(node.duplicate())
		print("node copied")

#func _on_duplicate_nodes_request() -> void:
	#duplicate_selected_nodes()
