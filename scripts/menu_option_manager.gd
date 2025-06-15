extends Control

signal clear_graph
@export var Graph_Edit: GraphEdit
@onready var save_file_dialog: FileDialog = $SaveFileDialog
@onready var open_file_dialog: FileDialog = $OpenFileDialog
const GRAPH_NODE = preload("res://scenes/graph_node.tscn")
const HEAD_NODE = preload("res://scenes/HEAD.tscn")

enum FileMenuOptions {
	NEW_GRAPH,
	CREATE_NODE,
	CREATE_HEAD_NODE,
	#SAVE_AS_JSON
	SAVE_AS_RESOURCE,
}

enum OpenMenuPopup {
	OPEN_RESOURCE,
	#OPEN_JSON
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#RenderingServer.set_debug_generate_wireframes(true)
	#get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# MAKE THIS MORE REDABLE AND FRINDLY :<
func save_graph_as_resource(filename: String) -> void:
	var graph_data = GraphData.new()
	graph_data.connections = Graph_Edit.get_connection_list()
	for graphNode in Graph_Edit.get_children():
		if graphNode is GraphNode:
			var GRAPH_NODE_data = GraphNodeData.new()
			GRAPH_NODE_data.name = graphNode.name
			GRAPH_NODE_data.offset = graphNode.position_offset
			
			for subNode in graphNode.get_children():
				if subNode is HBoxContainer:
					var sub_node_data = SubNodeData.new()
					sub_node_data.topic = subNode.get_child(0).text
					GRAPH_NODE_data.subNodes.append(sub_node_data)
			graph_data.graphNodes.append(GRAPH_NODE_data)
	if ResourceSaver.save(graph_data, filename) == OK:
		print("reource saved")
	else:
		print("save failed")

# Extract graph data from the loaded resource file
func init_graph(Graph_Data: GraphData):
	for g_node_data in Graph_Data.graphNodes:
		var GRAPH_NODE = GRAPH_NODE.instantiate() as GraphNode
		GRAPH_NODE.position_offset = g_node_data.offset
		GRAPH_NODE.name = g_node_data.name
		#Graph_Edit.add_child(GRAPH_NODE)
		
		var slotIndex = 2
		for sub_node_data in g_node_data.subNodes:
			# Init first node as the HEAD node (TODO)
			var s_node = GRAPH_NODE.get_child(1).duplicate()
			s_node.get_child(0).text = sub_node_data.topic
			GRAPH_NODE.set_slot(slotIndex, true, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))
			slotIndex += 1
			GRAPH_NODE.add_child(s_node)
		
		Graph_Edit.add_child(GRAPH_NODE)
	
	for connection in Graph_Data.connections:
		print(connection)
		Graph_Edit.connect_node(connection.from_node, connection.from_port, connection.to_node, connection.to_port)
			

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
			pass
	else:
		# File not found
		pass

func create_head_node() -> void:
	var head = HEAD_NODE.instantiate() as GraphNode
	Graph_Edit.add_child(head)
	head.position_offset = Vector2(get_viewport_rect().size / 2)

func create_node() -> void:
	var gNode = GRAPH_NODE.instantiate() as GraphNode
	Graph_Edit.add_child(gNode)
	gNode.position_offset = Vector2(get_viewport_rect().size / 2)

func _on_file_menu_popup_id_pressed(id: int) -> void:
	match id:
		FileMenuOptions.NEW_GRAPH:
			emit_signal("clear_graph")
		FileMenuOptions.CREATE_HEAD_NODE:
			create_head_node()
		FileMenuOptions.CREATE_NODE:
			create_node()
		FileMenuOptions.SAVE_AS_RESOURCE:
			save_file_dialog.visible = true
			#save_graph_as_resource("res://new_resource.tres")


func _on_open_menu_popup_id_pressed(id: int) -> void:
	match id:
		OpenMenuPopup.OPEN_RESOURCE:
			open_file_dialog.visible = true
			#load_graph_as_resource("res://new_resource.tres")


func _on_save_file_dialog_file_selected(path: String) -> void:
	save_graph_as_resource(path)


func _on_open_file_dialog_file_selected(path: String) -> void:
	emit_signal("clear_graph")
	# Need to call this at the end of the frame to avoid colliding with clear_graph() function
	# Might cause bugs need to kept observed
	call_deferred("load_graph_as_resource", path)
	#load_graph_as_resource(path)
