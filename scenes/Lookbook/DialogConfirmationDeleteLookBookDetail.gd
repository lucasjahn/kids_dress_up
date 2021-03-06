extends MarginContainer

signal dialog_confirmed

func _ready():
	for child in $Background/OverlayWrapper/VBoxContainer/CenterContainer/ButtonWrapper.get_children():
		child.connect("pressed", self, "_on_buttonPressed", [child.get_name()])


func _on_buttonPressed(nodeName):
	var status = null

	if nodeName == 'Ok':
		status = true
	elif nodeName == 'Cancel':
		status = false

	emit_signal("dialog_confirmed", status)