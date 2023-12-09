extends CanvasLayer

class_name GUIMainPanel

var _client: GClient
var is_running_in_editor = false

var moving_cursor = false
var _was_dragging = false

func initialize(client: GClient):
	_client = client
	is_running_in_editor = OS.has_feature("editor")
	
	$MarginContainer/Control/PanelTouchPad/TextureRectCursorSimulator.visible = is_running_in_editor

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
		$MarginContainer/Control/PanelTouchPad/TextureRectCursorSimulator/LabelSimulationAction.text = "left click"
		$MarginContainer/Control/PanelTouchPad/TextureRectCursorSimulator/LabelSimulationAction/AnimationPlayer.play("RESET")
		$MarginContainer/Control/PanelTouchPad/TextureRectCursorSimulator/LabelSimulationAction/AnimationPlayer.play("show_simulator_debug_text")
		return
	
	_client.send_press_mouse_button(GXInput.GX_MOUSE_BUTTON_LEFT)

func _on_button_right_click_pressed():
	print("right clicked")
	if is_running_in_editor:
		$MarginContainer/Control/PanelTouchPad/TextureRectCursorSimulator/LabelSimulationAction.text = "right click"
		$MarginContainer/Control/PanelTouchPad/TextureRectCursorSimulator/LabelSimulationAction/AnimationPlayer.play("RESET")
		$MarginContainer/Control/PanelTouchPad/TextureRectCursorSimulator/LabelSimulationAction/AnimationPlayer.play("show_simulator_debug_text")
		return

	_client.send_press_mouse_button(GXInput.GX_MOUSE_BUTTON_RIGHT)

func _on_button_play_pause_pressed():
	print("play/plause clicked")
	_client.send_press_virtual_key(GXInput.GX_VIRTUAL_KEY_PLAY_PAUSE)

func _on_button_forward_pressed():
	print("play/plause clicked")
	_client.send_press_virtual_key(GXInput.GX_VIRTUAL_KEY_NEXT_TRACK)


func _on_button_backwards_pressed():
	print("play/plause clicked")
	_client.send_press_virtual_key(GXInput.GX_VIRTUAL_KEY_PREVIOUS_TRACK)

func _open_config_panel():
	$UIPanelConfig/ControlContainer/LineEditHost.text = GConfig.host
	$UIPanelConfig/ControlContainer/LineEditPort.text = str(GConfig.port)
	$UIPanelConfig.visible = true

func _on_button_connect_pressed():
	var host : String = $UIPanelConfig/ControlContainer/LineEditHost.text
	var port_text : String = $UIPanelConfig/ControlContainer/LineEditPort.text
	var label_result : Label = $UIPanelConfig/ControlContainer/LabelResult as Label
	var port : int = -1
	
	if host.length() == 0:
		label_result.text = "Host is required"
		return
	
	if port_text.length() == 0:
		label_result.text = "Port is required"
		return
		
	port = int(port_text)
	
	if str(port) != port_text:	# fix entered value
		$Control/UIPanelConfig/ControlContainer/LineEditPort.text = str(port)
	
	label_result.text = "Connecting..."
	var result : String = "noooo"
	result = await _client.try_connect_client(host,port)
	
	if result.length() > 0:
		label_result.text = result
		return
	
	label_result.text = "Successfully connected"
	_on_button_close_config_pressed()

func _on_button_close_config_pressed():
	$UIPanelConfig.visible = false

func _on_update_connection_status(connection_status: int):
	var text = ""
	
	if connection_status == StreamPeerTCP.STATUS_CONNECTED:
		text = "Status: [color=green]Connected[/color]"
	elif connection_status == StreamPeerTCP.STATUS_CONNECTING:
		text = "Status: [color=gray]Connecting[/color]"
	else:
		text = "Status: [color=red]Disconnected[/color]"
	
	$MarginContainer/Control/HBoxContainerHeader/RichTextLabelStatus.text = text
	$UIPanelConfig/ControlContainer/RichTextLabelStatus.text = text
