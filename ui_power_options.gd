extends Panel
class_name UIPowerOptions

@export var confirm_panel : ConfirmationDialog

signal _selected_option(confirmed: bool)
signal confirmed_option(power_option: int)

func _on_button_close_pressed() -> void:
	visible = false


func _on_button_sleep_pressed() -> void:
	confirm_panel.dialog_text = "Are you sure you want to Sleep"
	confirm_panel.show()

	var confirmed = await _selected_option

	if not confirmed:
		return

	confirmed_option.emit(GConstants.POWER_OPTION_SLEEP)


func _on_button_shutdown_pressed() -> void:
	confirm_panel.dialog_text = "Are you sure you want to Shutdown (forced)"
	confirm_panel.show()

	var confirmed = await _selected_option

	if not confirmed:
		return

	confirmed_option.emit(GConstants.POWER_OPTION_SHUTDOWN)


func window_selected_option(confirmed: bool):
	_selected_option.emit(confirmed)
