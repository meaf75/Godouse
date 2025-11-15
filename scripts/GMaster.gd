extends Node

class_name GMaster

@export var move_multiplier : float = 5
@export var initialize_client : bool = false
@export var initialize_server : bool = false

@export var label_simulation_action : Label
@export var texture_cursor_simulator : TextureRect

var new_pos : Vector2

var moving_cursor = false
var last_touch_start = Vector2.ZERO

var server : GServer
var client : GClient
var ui_panel : GUIMainPanel

var thread : Thread

var is_running_in_editor = OS.has_feature("editor")
var is_running_in_mobile : bool = OS.get_name() == "Android"


#var _tray : GXTraypp

# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_running_in_editor:
		initialize_client = false
		initialize_server = false

	server = $Server as GServer
	client = $Client as GClient
	ui_panel = $UIMainPanel as GUIMainPanel

	label_simulation_action.text = ""

	if !is_running_in_mobile || initialize_server:
		server.initialize(self)

		thread = Thread.new()
		#thread.start(_start_system_tray.bind($GXTraypp))
		#$GXTraypp.on_receive_exit_request.connect(exit_game)

	if is_running_in_mobile || initialize_client:
		print("running mobile initialization")
		ui_panel.initialize(client)
		client.initialize()

func _input(ev):
	if ev is InputEventKey and ev.keycode == KEY_SPACE and ev.pressed:
		print("debug action")
		return

	if is_running_in_editor && ev is InputEventKey:
		match (ev as InputEventKey).keycode:
			KEY_W:
				client.send_cursor_movement(Vector2.ZERO, Vector2.UP)
			KEY_A:
				client.send_cursor_movement(Vector2.ZERO, Vector2.LEFT)
			KEY_S:
				client.send_cursor_movement(Vector2.ZERO, Vector2.DOWN)
			KEY_D:
				client.send_cursor_movement(Vector2.ZERO, Vector2.RIGHT)
			KEY_Q:
				client.send_press_mouse_button(GodouseInputConstants.MOUSE_BUTTON_LEFT_CLICK)
			KEY_E:
				client.send_press_mouse_button(GodouseInputConstants.MOUSE_BUTTON_RIGHT_CLICK)

func _on_receive_move_request(offset: Vector2):
	texture_cursor_simulator.set_position(texture_cursor_simulator.position + offset * move_multiplier)

#func _start_system_tray(tray: GXTraypp):
	#_tray = tray
	#var icon_path = ProjectSettings.globalize_path("res://images/icon.ico")
	#print("Starting system tray, icon: ", icon_path)
#
	#_tray.add_to_system_tray("Godouse", icon_path)

func _exit_tree():
	#_tray.stop_system_tray()
	thread.wait_to_finish()

func exit_game():
	get_tree().quit()
