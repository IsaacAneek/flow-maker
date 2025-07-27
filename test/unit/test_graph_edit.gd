extends GutTest

var selected_nodes = {}
const GRAPH_NODE = preload("res://scenes/graph_node.tscn")
const HEAD_NODE = preload("res://scenes/HEAD.tscn")
const SUBNODE_H_BOX_CONTAINER = preload("res://scenes/subnode_h_box_container.tscn")
@onready var GRAPH_EDIT = preload("res://scenes/graph_edit.tscn")

var graph_edit
var json_paths = [
	"res://examples/jsons/slam2.json",
	"res://examples/jsons/slam.json",
	"res://examples/jsons/multispectral imaging.json",
	"res://examples/jsons/exp.json"
]
var loaded_data = {}

func test_load_graph_check_connections(path = use_parameters(json_paths)):
	gut.p("Checking if the connection info are same")
	assert_eq_deep(loaded_data[path]["file"]["connections"], loaded_data[path]["graph"]["connections"])

func test_load_graph_check_graph_nodes(path = use_parameters(json_paths)):
	gut.p("Checking if graph_nodes info are same")
	assert_eq_deep(loaded_data[path]["file"]["graph_nodes"], loaded_data[path]["graph"]["graph_nodes"])

func test_load_graph_check_version(path = use_parameters(json_paths)):
	gut.p("Checking version info mismatch")
	assert_eq_deep(loaded_data[path]["file"]["version"], loaded_data[path]["graph"]["version"])

func before_all():
	graph_edit = GRAPH_EDIT.instantiate()
	add_child(graph_edit)
	
	for path in json_paths:
		graph_edit.clear_graph()
		graph_edit.load_graph(path)

		var json_from_graph = JSON.parse_string(JSON.stringify(graph_edit.convert_graph_to_JSON_dictionary()))
		var json_from_file = graph_edit.open_and_init_JSON(path)

		loaded_data[path] = {
			"graph": json_from_graph,
			"file": json_from_file
		}

func after_all():
	graph_edit.queue_free()
