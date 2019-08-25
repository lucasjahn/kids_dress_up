extends Node2D

signal changed_color
signal closed
signal opened
signal save_look

const assetRootPath = 'res://assets/wardrobe'
var currentCategory : TextureRect = null
var currentColor = 'blue'

onready var contextualButtons = {
	'back': $ContextualButtons/ButtonBack,
	'color': $ContextualButtons/ButtonColor,
	'trash': $ContextualButtons/ButtonDelete,
	'lookbook': $ContextualButtons/ButtonSaveToLookbook
}
onready var home = $Home
onready var sidebar = $Sidebar
onready var clickSfx = $Click
onready var colorPickerScene = get_parent().get_node('ColorPicker')


func _ready():
	colorPickerScene.connect("color_selected", self, "_on_ColorPicker_color_selected")
	closeWardrobe()
	

func closeWardrobe():
	contextualButtons.back.hide()
	contextualButtons.color.hide()
	home.show()
	sidebar.hide()
	
	if currentCategory:
		currentCategory.hide()
		
	emit_signal("closed")
		

func openWardrobe(category):
	home.hide()
	sidebar.show()
	
	var newCategory = get_node('Categories/%s' % category)
	
	load_category(newCategory)
	currentCategory = newCategory
	
	emit_signal("opened")


func _on_Button_Back_pressed():
	clickSfx.pitch_scale = 1
	clickSfx.play(0)
	closeWardrobe()
	
	
func save_look():
    emit_signal("save_look")


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
			categoryItem.texture_normal = getColorTexture(category.get_name().to_lower(), currentColor, itemName)
		else:
			categoryItem.texture_normal = getTexture(category.get_name().to_lower(), itemName)
			
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
