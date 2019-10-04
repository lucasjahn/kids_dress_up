extends VBoxContainer

# warning-ignore:unused_class_variable
export var isColored : bool
# warning-ignore:unused_class_variable
export var texturePrefix : String
export var scaleFactor : float = 0.6

var boughtProducts = []

onready var sceneRoot : MarginContainer = get_tree().get_root().get_node('Main')
onready var clickSfx = sceneRoot.get_node('Sfx/Click')
onready var storeDialog : MarginContainer = sceneRoot.get_node('Store')
onready var lockTexture : Texture = preload("res://assets/lock.png")
signal colorSelected

func _ready():
	load_and_resize_items()
	
		
func load_and_resize_items(shouldResisze=true):
	boughtProducts = storeDialog.load_bought_products() if storeDialog.load_bought_products() else []
	
	for child in get_children():
		var button = child.get_children()[0]
		
		if shouldResisze:
			_set_min_size(button)
		
		if 'product_id' in child and child.product_id:	
			if child.purchased or _was_bought(child):
				_connect_to_wardrobe(button, child.get_name())
			else:
				_connect_to_store(child, button)
		else:
			_connect_to_wardrobe(button, child.get_name())
	
	
func _connect_to_wardrobe(node, name):
	var nodeContainer = node.get_parent()
	
	if node.is_connected("pressed", self, "_open_store"):
		node.disconnect("pressed", self, "_open_store")
		
	if nodeContainer.get_child_count() > 1:
		var lockNode = nodeContainer.get_child(1)
		
		nodeContainer.remove_child(lockNode)
		lockNode.queue_free()
		
		node.modulate.a = 1
	
	if not node.is_connected("pressed", self, "_on_buttonPressed"):
		node.connect("pressed", self, "_on_buttonPressed", [self, name])
	
	
func _was_bought(node):
	if node.product_id and len(boughtProducts) > 0 and node.product_id in boughtProducts:
		node.purchased = true
		return true
	else: 
		node.purchased = false
		return false
	
func _connect_to_store(buttonContainer : CenterContainer, button : TextureButton):
	if not button.is_connected("pressed", self, "_open_store"):
		var lockWrapper = CenterContainer.new()
		var lockNode = TextureRect.new()
		
		# set lock texture and disable mous events
		lockNode.texture = lockTexture
		lockNode.set_mouse_filter(MOUSE_FILTER_IGNORE)
		
		# add lock to the sorrounding center container and disable mouse events as well
		lockWrapper.add_child(lockNode)
		lockWrapper.set_mouse_filter(MOUSE_FILTER_IGNORE)
		
		# change opacity to 40% of button and add lock as a child of button container
		button.modulate.a = 0.4
		buttonContainer.add_child(lockWrapper)
	
		button.connect("pressed", self, "_open_store")
	
	
func _open_store():
	clickSfx.play(0)
	storeDialog.show()
	
func _on_buttonPressed(category, itemName):
	emit_signal("colorSelected", category, itemName)


func _set_min_size(node): 
	node.set_custom_minimum_size(Vector2(node.rect_size.x*scaleFactor, node.rect_size.y*scaleFactor))
	node.expand = true