extends MarginContainer

onready var button_list = $StoreWrapper/StoreRect/Container/ButtonsContainer

func _ready():
	for button in button_list.get_children(): 
		button.get_child(0).connect('pressed', self, '_on_buy_clicked')
	
	
func _on_buy_clicked():
	print('Gekoooft!')



func _on_CloseButton_pressed():
	self.hide()
