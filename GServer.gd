extends Node

class_name GServer

var server : TCPServer
var clients : Array[StreamPeerTCP] = []

var _master : GMaster

signal on_receive_move_cursor_request(offset: Vector2)

func initialize(master: GMaster):
	_master = master
	server = TCPServer.new()
	var err = server.listen(GConfig.port)

	if err:
		push_error(err)
		return

	print("Godouse server started at port: ", GConfig.port)

func _process(delta):
	
	if server == null:
		return
	
	if server.is_connection_available():
		print("new client connected")
		clients.append(server.take_connection())
		
	for c in clients:
		
		c.poll()
		
		if c.get_status() != StreamPeerTCP.STATUS_CONNECTED:
			continue
		
		if c.get_available_bytes() == 0:
			continue

		handle_action(c.get_var())

func handle_action(action: Dictionary):	
	if not action.has("type"):
		push_error("action does not contain type")
		return

	match action["type"] as int:
		GConstants.TCP_MESSAGE_TYPE_MOVE_CURSOR:
			# Move cursor
			#var next_position = DisplayServer.mouse_get_position() as Vector2 + (offset * _master.move_multiplier)
			var next_position = GXInput.get_cursor_position() + action["relative"] * 4

			if not _master.initialize_client:
				GXInput.set_cursor_position(next_position)
			else: 
				on_receive_move_cursor_request.emit(action["relative"])
		GConstants.TCP_MESSAGE_TYPE_PRESS_CURSOR_BUTTON:
			GXInput.simulate_click(action["button"])
			pass
		GConstants.TCP_MESSAGE_TYPE_VIRTUAL_KEY:
			GXInput.simulate_virtual_key_click(action["button"])
			pass
		_:
			push_warning("unknown type received: ", action["type"])
