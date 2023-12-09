extends Node

class_name GMaster

@export var move_multiplier : float = 5
@export var initialize_client : bool = false
@export var initialize_server : bool = false

var new_pos : Vector2

var moving_cursor = false
var last_touch_start = Vector2.ZERO

var server : GServer
var client : GClient
var ui_panel : GUIMainPanel

var is_running_in_editor = OS.has_feature("editor")
var is_running_in_mobile : bool = OS.get_name() == "Android"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if not is_running_in_editor:
		initialize_client = false
		initialize_server = false
	
	#await get_tree().create_timer(3).timeout
	#GXInput.simulate_click(GXInput.GX_MOUSE_BUTTON_RIGHT)	
	#return
	server = $Server as GServer
	client = $Client as GClient
	ui_panel = $UIMainPanel as GUIMainPanel
	var os_name = OS.get_name()
	
	$UIMainPanel/MarginContainer/Control/PanelTouchPad/TextureRectCursorSimulator/LabelSimulationAction.text = ""
	
	if !is_running_in_mobile || initialize_server:
		server.initialize(self)
		
		if is_running_in_editor:
			server.on_receive_move_cursor_request.connect(_on_receive_move_request)

	if is_running_in_mobile || initialize_client:
		ui_panel.initialize(client)
		client.initialize()
	
	if initialize_client:
		client.try_connect_client(GConfig.host,GConfig.port)

func _input(ev):
	if ev is InputEventMouseMotion:
		return

	if ev is InputEventKey and ev.keycode == KEY_SPACE and ev.pressed:
		print("debug action")
		#print(GXInput.get_cursor_position())
		
		return
		var rng = RandomNumberGenerator.new()
		var screen_size = DisplayServer.screen_get_size(0)
		new_pos = Vector2(rng.randi_range(0,screen_size.x), rng.randi_range(0,screen_size.y))
		Input.warp_mouse(new_pos)

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

func _on_receive_move_request(offset: Vector2):	
	var cursor_simulator = $UIMainPanel/MarginContainer/Control/PanelTouchPad/TextureRectCursorSimulator
	cursor_simulator.set_position(cursor_simulator.position + offset * move_multiplier) 
