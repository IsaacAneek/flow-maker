extends Node

var last_selected_path: String = ""
@export var Graph_Edit: GraphEdit
@onready var save_file_dialog: FileDialog = $"../SaveFileDialog"
@onready var open_file_dialog: FileDialog = $"../OpenFileDialog"
@onready var file_menu_popup: PopupMenu = $"../Panel/MenuBar/FileMenuPopup"
@onready var open_menu_popup: PopupMenu = $"../Panel/MenuBar/OpenMenuPopup"

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
	save_file_dialog.connect("files_selected", _on_save_file_dialog_file_selected)
	open_file_dialog.connect("files_selected", _on_open_file_dialog_file_selected)
	file_menu_popup.connect("id_pressed", _on_file_menu_popup_id_pressed)
	open_menu_popup.connect("id_pressed", _on_open_menu_popup_id_pressed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_file_menu_popup_id_pressed(id: int) -> void:
	match id:
		FileMenuOptions.NEW_GRAPH:
			last_selected_path = ""
			Graph_Edit.clear_graph()
		FileMenuOptions.CREATE_HEAD_NODE:
			Graph_Edit.create_head_node()
		FileMenuOptions.CREATE_NODE:
			Graph_Edit.create_node()
		FileMenuOptions.SAVE_AS_RESOURCE:
			save_file_dialog.visible = true


func _on_open_menu_popup_id_pressed(id: int) -> void:
	match id:
		OpenMenuPopup.OPEN_RESOURCE:
			open_file_dialog.visible = true


func _on_save_file_dialog_file_selected(path: String) -> void:
	last_selected_path = path
	Graph_Edit.save_graph_as_resource(path)


func _on_open_file_dialog_file_selected(path: String) -> void:
	last_selected_path = path
	#Graph_Edit.clear_connections()
	Graph_Edit.clear_graph()
	Graph_Edit.load_graph_as_resource(path)
	
