extends MarginContainer

var timer = null
var is_timed_out = false

onready var clickSfx = $Sfx/Click
onready var timer_btn_list = $TextureRect/CenterContainer/TextureRect/VBoxContainer/BtnsTimer/HBoxContainer

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)
	for timer_btn in timer_btn_list.get_children():
		timer_btn.connect("pressed", self, "_on_buttonPressed", [timer_btn.wait_time])
		
func _on_buttonPressed(wait_time):
	clickSfx.play(0)
	is_timed_out = false
	timer.set_wait_time(wait_time)
	timer.start()
	self.hide()


func _on_timeout():
	is_timed_out = true
	self.get_parent().get_node("DialogSettings").open_scene()
	
	
func _on_Close_pressed():
	clickSfx.play(0)
	is_timed_out = false
	self.hide()
	
