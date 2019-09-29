extends MarginContainer

var InAppStore = Engine.get_singleton("InAppStore")

onready var sceneRoot : MarginContainer = get_tree().get_root().get_node('Main')
onready var clickSfx = sceneRoot.get_node('Sfx/Click')
onready var button_list = $StoreWrapper/StoreRect/Container/ButtonsContainer

func _ready():
	for button in button_list.get_children(): 
		var buttonNode = button.get_child(0)
		buttonNode.connect('pressed', self, '_on_buy_clicked', [buttonNode.product_id])
	
	
func _on_buy_clicked(product_id):
	clickSfx.play(0)
	
	var result = InAppStore.purchase( { "product_id": product_id } )
	
	if result == OK:
        print('result')
	else:
        print('error')



func _on_CloseButton_pressed():
	clickSfx.play(0)
	self.hide()
