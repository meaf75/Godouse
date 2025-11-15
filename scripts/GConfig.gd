extends Node

var port : int = 32075
var host : String = "192.168.20.22"
var cursor_speed : int = 50

var cfg : ConfigFile

const CONFIG_FILE_PATH : String = "user://godouse.cfg"


func _ready() -> void:
	cfg = ConfigFile.new()
	cfg.load(CONFIG_FILE_PATH)

	host = cfg.get_value("CONFIG", "host", host)
	port = cfg.get_value("CONFIG", "port", port)

	cursor_speed = cfg.get_value("CONFIG", "cursor_speed", cursor_speed)

func save():
	cfg.set_value("CONFIG", "host", host)
	cfg.set_value("CONFIG", "port", port)
	cfg.set_value("CONFIG", "cursor_speed", cursor_speed)
	cfg.save(CONFIG_FILE_PATH)
