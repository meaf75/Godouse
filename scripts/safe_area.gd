extends MarginContainer

func _ready() -> void:
	var os := OS.get_name()
	if os == "iOS" or os == "Android":
		update()

func update() -> void:
	var screen_safe_rect := Rect2(DisplayServer.get_display_safe_area())
	var viewport_transform := get_viewport().get_final_transform()
	var viewport_safe_rect := screen_safe_rect * viewport_transform.affine_inverse()
	var viewport_full_rect := get_viewport().get_visible_rect()
	var left := viewport_safe_rect.position.x - viewport_full_rect.position.x
	var top := viewport_safe_rect.position.y - viewport_full_rect.position.y
	var right := viewport_full_rect.end.x - viewport_safe_rect.end.x
	var bottom := viewport_full_rect.end.y - viewport_safe_rect.end.y
	begin_bulk_theme_override()
	add_theme_constant_override('margin_left', roundi(left))
	add_theme_constant_override('margin_top', roundi(top))
	add_theme_constant_override('margin_right', roundi(right))
	add_theme_constant_override('margin_bottom', roundi(bottom))
	end_bulk_theme_override()
