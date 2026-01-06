extends Node

class_name GClient

var client : StreamPeerTCP
var was_connected: bool

var reconnection_interval_s : float = 2
var current_reconnection_interval_s : float = 0

signal on_update_connection_status(connection_status: int)

func initialize():
	print("godouse client initialized")
	client = StreamPeerTCP.new()


func try_connect_client(host: String, port: int) -> String:
	if client.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		return "currently connecting"

	if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		return "Already connected to %s:%d" % [host, port]

	print("trying connection to %s:%d" % [host, port])
	on_update_connection_status.emit(StreamPeerTCP.STATUS_CONNECTING)
	var err = client.connect_to_host(host,port)

	var timeout = get_tree().create_timer(reconnection_interval_s)

	while timeout.time_left > 0:
		if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			# all ok
			GConfig.host = host
			GConfig.port = port
			on_update_connection_status.emit(StreamPeerTCP.STATUS_CONNECTED)
			was_connected = true
			send_cursor_speed(GConfig.cursor_speed)
			return ""

		await get_tree().process_frame

	# timeout
	client.disconnect_from_host()
	on_update_connection_status.emit(StreamPeerTCP.STATUS_ERROR)
	print("[error] error trying connection to %s:%d" % [host, port])
	return "error connecting client\n%s:%d\nerror code: %d" % [host,port,err]


func _process(delta):
	if client == null:
		return

	client.poll()

	# try connect
	if client.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		if current_reconnection_interval_s < 0:
			current_reconnection_interval_s = reconnection_interval_s + 1
			try_connect_client(GConfig.host, GConfig.port)
		else:
			current_reconnection_interval_s -= delta

		return

	# listen
	if was_connected && client.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		on_update_connection_status.emit(StreamPeerTCP.STATUS_ERROR)
		client.disconnect_from_host()
		was_connected = false


func send_cursor_movement(velocity: Vector2, relative: Vector2):
	client.put_var({
		type = GConstants.TCP_MESSAGE_TYPE_MOVE_CURSOR,
		relative = relative,
		velocity = velocity
	})


func send_press_mouse_button(button: int):
	client.put_var({
		type = GConstants.TCP_MESSAGE_TYPE_PRESS_CURSOR_BUTTON,
		button = button
	})


func send_press_virtual_key(button: int):
	client.put_var({
		type = GConstants.TCP_MESSAGE_TYPE_VIRTUAL_KEY,
		button = button
	})


func send_cursor_speed(speed: int):
	client.put_var({
		type = GConstants.TCP_MESSAGE_TYPE_CURSOR_SPEED,
		speed = speed
	})


func send_power_action(power_option: int):
	client.put_var({
		type = GConstants.TCP_MESSAGE_TYPE_POWER_ACTION,
		value = power_option
	})
