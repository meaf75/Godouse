extends Node

class_name GServer

var server : TCPServer
var clients : Array[StreamPeerTCP] = []
var clients_disconnected : Array[StreamPeerTCP] = []

var _master : GMaster
var godouse_input: GodouseInput

func initialize(master: GMaster):
	_master = master
	server = TCPServer.new()

	godouse_input = GodouseInput.new()
	godouse_input.setup()

	var err = server.listen(GConfig.port)

	if err:
		push_error(err)
		return

	print("Godouse server started at port: ", GConfig.port)

func _process(_delta):
	if server == null:
		return

	if server.is_connection_available():
		print("new client connected")
		clients.append(server.take_connection())

	for c in clients:
		c.poll()

		# Check if disconnected
		var conn_status = c.get_status();
		if conn_status != StreamPeerTCP.STATUS_CONNECTED:
			if conn_status == StreamPeerTCP.STATUS_NONE:
				clients_disconnected.append(c)
			continue

		if c.get_available_bytes() == 0:
			continue

		handle_action(c.get_var())

	if clients_disconnected.size() > 0:
		for c in clients_disconnected:
			clients.erase(c)
			print("Client disconnected")

		clients_disconnected.clear()


func handle_action(action: Dictionary):
	if not action.has("type"):
		push_error("action does not contain type")
		return

	match action["type"] as int:
		GConstants.TCP_MESSAGE_TYPE_MOVE_CURSOR:
			# Move cursor
			#var next_position = DisplayServer.mouse_get_position() as Vector2 + (offset * _master.move_multiplier)
			var relative = action["relative"]
			var next_position : Vector2 = godouse_input.get_cursor_position() + action["relative"] * GConfig.cursor_speed * get_process_delta_time()

			if sign(relative.x) == 1:
				next_position.x = ceil(next_position.x)
			else:
				next_position.x = floor(next_position.x)

			if sign(relative.y) == 1:
				next_position.y = ceil(next_position.y)
			else:
				next_position.y = floor(next_position.y)

			#print("relative: %v, curr_pos: %v, next_pos: %v, delta: %f" % [relative, godouse_input.get_cursor_position(), next_position, get_process_delta_time()])
			godouse_input.move_mouse_to(round(next_position.x), round(next_position.y))

		GConstants.TCP_MESSAGE_TYPE_PRESS_CURSOR_BUTTON:
			print("sending: ", action["button"])
			godouse_input.simulate_button(action["button"])
			pass
		GConstants.TCP_MESSAGE_TYPE_VIRTUAL_KEY:
			#GXInput.simulate_virtual_key_click(action["button"])
			pass
		GConstants.TCP_MESSAGE_TYPE_CURSOR_SPEED:
			if action["speed"] is int:
				GConfig.cursor_speed = action["speed"]
				print("updating cursor speed to %d" % GConfig.cursor_speed)
		_:
			push_warning("unknown type received: ", action["type"])
