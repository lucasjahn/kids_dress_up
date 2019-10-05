extends MarginContainer

onready var label = $CenterContainer/DialogBackground/CenterContainer/MarginContainer/Label

func _ready():
	Events.connect("loading_start", self, "_on_loading_start")
	Events.connect("loading_end", self, "_on_loading_end")


func _on_loading_start(infoText):
	label.text = infoText
	self.show()
	
	
func _on_loading_end():
	self.hide()