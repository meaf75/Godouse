extends CanvasLayer

class_name GUIMainPanel

@export var texture_cursor_simulator : TextureRect
@export var label_simulation_action : Label
@export var label_simulation_action_animator : AnimationPlayer

@export var label_status : RichTextLabel

@export var ui_power_options: UIPowerOptions

@export_category("Panel Config")
@export var panel_config : Panel
@export var config_label_status : RichTextLabel
@export var config_label_result : Label
@export var input_host : LineEdit
@export var input_port : LineEdit
@export var input_cursor_speed : LineEdit



var _client: GClient
var is_running_in_editor = false

var moving_cursor = false
var _was_dragging = false

func initialize(client: GClient):
	_client = client
	is_running_in_editor = OS.has_feature("editor")

	texture_cursor_simulator.visible = is_running_in_editor


func _input(event):
	if not event is InputEventScreenDrag || !moving_cursor:
		return

	var evt = event as InputEventScreenDrag;
	_was_dragging = true
	_client.send_cursor_movement(evt.velocity, evt.relative)


func _on_panel_touch_pad_button_down():
	_was_dragging = false
	moving_cursor = true


func _on_panel_touch_pad_button_up():
	_was_dragging = false
	moving_cursor = false


func _on_button_left_click_pressed():

	if _was_dragging:
		return

	print("left clicked")
	if is_running_in_editor:
		label_simulation_action.text = "left click"
		label_simulation_action_animator.play("RESET")
		label_simulation_action_animator.play("show_simulator_debug_text")
		return

	_client.send_press_mouse_button(GodouseInputConstants.MOUSE_BUTTON_LEFT_CLICK)


func _on_button_right_click_pressed():
	print("right clicked")
	if is_running_in_editor:
		label_simulation_action.text = "right click"
		label_simulation_action_animator.play("RESET")
		label_simulation_action_animator.play("show_simulator_debug_text")
		return

	_client.send_press_mouse_button(GodouseInputConstants.MOUSE_BUTTON_RIGHT_CLICK)


func _on_button_play_pause_pressed():
	print("play/plause clicked")
	_client.send_press_mouse_button(GodouseInputConstants.MEDIA_KEY_PLAY_PAUSE)


func _on_button_forward_pressed():
	print("forward clicked")
	_client.send_press_virtual_Ukey(GodouseInputConstants.MEDIA_KEY_NEXT_TRACK)


func _on_button_backwards_pressed():
	print("backward clicked")
	_client.send_press_virtual_Ukey(GodouseInputConstants.MEDIA_KEY_PREVIOUS_TRACK)


func _open_config_panel():
	input_host.text = GConfig.host
	input_port.text = str(GConfig.port)
	input_cursor_speed.text = str(GConfig.cursor_speed)
	panel_config.visible = true


func _on_button_connect_pressed():
	var host : String = input_host.text
	var port_text : String = input_port.text
	var port : int = -1

	if host.length() == 0:
		config_label_result.text = "Host is required"
		return

	if port_text.length() == 0:
		config_label_result.text = "Port is required"
		return

	port = int(port_text)

	if str(port) != port_text:	# fix entered value
		input_port.text = str(port)

	config_label_result.text = "Connecting..."
	var result : String = "noooo"
	result = await _client.try_connect_client(host,port)

	if result.length() > 0:
		config_label_result.text = result
		return

	config_label_result.text = "Successfully connected"
	_on_button_close_config_pressed()


func _on_button_close_config_pressed():
	panel_config.visible = false


func _on_update_connection_status(connection_status: int):
	var text = ""

	if connection_status == StreamPeerTCP.STATUS_CONNECTED:
		text = "Status: [color=green]Connected[/color]"
	elif connection_status == StreamPeerTCP.STATUS_CONNECTING:
		text = "Status: [color=gray]Connecting[/color]"
	else:
		text = "Status: [color=red]Disconnected[/color]"

	label_status.text = text
	config_label_status.text = text


func _on_modify_config_value(_v : String):

	if input_cursor_speed.text.is_valid_int() && input_cursor_speed.text.to_int() != GConfig.cursor_speed:
		_client.send_cursor_speed(input_cursor_speed.text.to_int())

	GConfig.host = input_host.text
	GConfig.port = input_port.text.to_int()
	GConfig.cursor_speed = input_cursor_speed.text.to_int()
	GConfig.save()


# Power screen
func _on_power_button_pressed() -> void:
	ui_power_options.visible = true


func _on_ui_power_options_confirmed_option(power_option: int) -> void:
	_client.send_power_action(power_option)
