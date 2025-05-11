## Godot has good support for nine-patch rectangles and even support for
## nine-patch containers using PanelContainers with a StyleBoxTexture, but doing
## so does not let you specify a background independently or customize the
## margins.  Content is always placed only in the middle cell of the nine-patch.
##
## By using Margin containers and NinePatchRects, we can dynamically compose
## nine-patch containers that allow customization of these elements.
##
## This control uses child ordering to ensure that the background is drawn first,
## then the nine-patch frame, then the content.  Either use the button to create
## reasonable defaults, or create your content and assign it to the exported
## properties.


@tool
extends MarginContainer

#-----
# @export variables
#-----
@export_category("Background (Optional)")
@export var background_node: Control:
	get: return _background_node
	set(value):
		if _background_node:
			remove_child(_background_node)
		_background_node = value
		if value:
			add_child(value)
			move_child(value, 0)  # Background should be first (bottom)
		update_configuration_warnings()

@export_tool_button("Create Default") var create_default_background_action = create_default_background


@export_category("Frame")
@export var frame_node: Control:
	get: return _frame_node
	set(value):
		if _frame_node:
			remove_child(_frame_node)
		_frame_node = value
		if value:
			add_child(value)
			move_child(value, 1)  # Frame should be second (middle)
		update_configuration_warnings()


@export_tool_button("Create Default") var create_default_frame_action = create_default_frame

@export_category("Content")
@export var content_node: Control:
	get: return _content_node
	set(value):
		if _content_node:
			remove_child(_content_node)
		_content_node = value
		if value:
			add_child(value)
			move_child(value, 2)  # Content should be last (top)
		update_configuration_warnings()

@export_tool_button("Create Default") var create_default_content_action = create_default_content

#-----
# Member variables
#-----
var _background_node: Control
var _frame_node: Control
var _content_node: Control

#-----
# Built-in virtual methods
#-----
func _ready() -> void:
	update_configuration_warnings()

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		if Engine.is_editor_hint():
			update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if not _frame_node:
		warnings.append("Frame node is not set")
	if not _content_node:
		warnings.append("Content node is not set")

	return warnings

#-----
# Editor methods
#-----
func create_default_background() -> void:
	if _background_node:
		_background_node.queue_free()

	var container = MarginContainer.new()
	container.name = "Background"
	background_node = container
	container.owner = owner
	update_configuration_warnings()


func create_default_frame() -> void:
	if _frame_node:
		_frame_node.queue_free()

	var frame = NinePatchRect.new()
	frame.name = "Frame"
	frame_node = frame
	frame.owner = owner
	update_configuration_warnings()


func create_default_content() -> void:
	if _content_node:
		_content_node.queue_free()

	var container = MarginContainer.new()
	container.name = "Content"
	content_node = container
	container.owner = owner
	update_configuration_warnings()
