extends MarginContainer

signal changed_color
signal closed
signal opened

const assetRootPath = 'res://assets/wardrobe'
var currentCategory : VBoxContainer = null
var currentColor = 'blue'

onready var sceneRoot = get_tree().get_root().get_node('Main')
onready var contextualButtons = {
	'back': sceneRoot.get_node('MainSceneContainer/ButtonLeftContainer/VBoxContainer/ButtonsTop/ButtonBack'),
	'color': sceneRoot.get_node('MainSceneContainer/Wardrobe/OpenWardrobeContainer/OpenWardrobeCols/SidebarContainer/Sidebar/ButtonColor'),
	'trash': sceneRoot.get_node('MainSceneContainer/ButtonRightContainer/VBoxContainer/ButtonsBottom/ButtonDelete'),
	'lookbook': sceneRoot.get_node('MainSceneContainer/ButtonLeftContainer/VBoxContainer/ButtonsBottom/ButtonSaveToLookbook')
}
onready var home = sceneRoot.get_node('MainSceneContainer/Wardrobe/WardrobeMenuContainer')
onready var openWardrobeNode = sceneRoot.get_node('MainSceneContainer/Wardrobe/OpenWardrobeContainer')
onready var clickSfx = sceneRoot.get_node('Sfx/Click')
onready var colorPickerScene = sceneRoot.get_node('ColorPicker')


func _ready():
	colorPickerScene.connect("color_selected", self, "_on_ColorPicker_color_selected")
	closeWardrobe()
	

func closeWardrobe():
	contextualButtons.back.hide()
	contextualButtons.color.hide()
	home.show()
	openWardrobeNode.hide()
	
	if currentCategory:
		currentCategory.hide()
		
	emit_signal("closed")
		

func openWardrobe(category):
	home.hide()
	openWardrobeNode.show()
	
	var newCategory = get_node('OpenWardrobeContainer/OpenWardrobeCols/OpenWardrobe/Categories/%s' % category)
	
	load_category(newCategory)
	currentCategory = newCategory
	
	emit_signal("opened")


func _on_Button_Back_pressed():
	clickSfx.pitch_scale = 1
	clickSfx.play(0)
	closeWardrobe()


func update_color(colorName):
	currentColor = colorName
	emit_signal("changed_color", currentColor)


func getTexture(category, itemName):
	return load("%s/%s/%s.png" % [assetRootPath, category, itemName])


func getColorTexture(category, color, itemName):
	return load("%s/%s/%s/%s.png" % [assetRootPath, category, color, itemName])

func load_category(category = currentCategory):
	if currentCategory:
		currentCategory.hide()
			
	for categoryItem in category.get_children(): 
		var itemName = categoryItem.get_name().to_lower()
		
		if category.texturePrefix:
			 itemName = category.texturePrefix + itemName
		
		if category.isColored:
			categoryItem.get_node('Button').texture_normal = getColorTexture(category.get_name().to_lower(), currentColor, itemName)
		else:
			categoryItem.get_node('Button').texture_normal = getTexture(category.get_name().to_lower(), itemName)
			
		category.show()
		contextualButtons.color.hide()
		contextualButtons.back.show()
	
	if category.isColored:
		contextualButtons.color.show()


func _on_ButtonColor_pressed():
	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)
	
	colorPickerScene.show()


func _on_ColorPicker_color_selected(colorName):
	
	update_color(colorName)
	
	colorPickerScene.hide()
	
	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)
	
	load_category()
