extends MarginContainer


var code_list = ["EINS", "ZWEI", "DREI", "VIER", "FÜNF"]
var code_sequence = []
var press_count = 0
var pressed_btns_sequence = []
var dialog_text = {
	"type_code":"Dieser Bereich ist geschützt\nBitte tippen Sie ein:",
	"timed_out":"Die Spielzeit ist abgelaufen\nZum Verlängern tippen Sie ein:"
}

var target_node

onready var clickSfx = $Sfx/Click
onready var wrongSfx = $Sfx/Wrong
onready var label_list = $TextureRect/CenterContainer/TextureRect/VBoxContainer/CodeSequence/HBoxCodeSequence
onready var btn_list = $TextureRect/CenterContainer/TextureRect/VBoxContainer/CodeButtons/HBoxContainer
onready var animation_player = $TextureRect/CenterContainer/TextureRect/AnimationPlayer
onready var close_btn = $TextureRect/CenterContainer/TextureRect/Close
onready var label = $TextureRect/CenterContainer/TextureRect/VBoxContainer/Text/MarginContainer/Label

func _ready():
	for btn in btn_list.get_children():
		btn.connect("pressed", self, "_on_buttonPressed", [btn.get_name()])


func _on_buttonPressed(btn_name):
	press_count += 1

	pressed_btns_sequence.append(btn_name)

	if press_count == 4:
		check_code()
	else:
		clickSfx.play(0)


func check_code():
	press_count = 0

	if pressed_btns_sequence == code_sequence:
		clickSfx.play(0)
		self.hide()

		target_node.show()

		if target_node.get_name() == 'Store':
			target_node.buy_item()

	else:
		wrongSfx.play(0)
		animation_player.play("WobbleWindow")


func open_scene(play_sound: = false, target_node_name: = "TimerSettings"):
	if target_node_name:
		target_node = self.get_parent().get_node(target_node_name)

		if play_sound:
			clickSfx.play(0)

		_reset_code()
		generate_codes()

		if target_node_name == "TimerSettings":
			if target_node.is_timed_out:
				label.text = dialog_text.timed_out
				close_btn.hide()
			else:
				label.text = dialog_text.type_code
				close_btn.show()

		self.show()


func generate_codes():
	for label in label_list.get_children():
		_write_code_to_label(label, _generate_single_code())


func _generate_single_code():
	var code = null
	randomize()
	code = code_list[randi() % code_list.size()]
	code_sequence.append(code)
	return code


func _write_code_to_label(label_node,code):
	label_node.text = code


func _reset_code():
	code_sequence = []
	pressed_btns_sequence = []
	press_count = 0


func _on_AnimationPlayer_animation_finished(anim_name):
	animation_player.stop(true)
	_reset_code()
	generate_codes()


func _on_Close_pressed():
	clickSfx.play(0)
	_reset_code()
	self.hide()
