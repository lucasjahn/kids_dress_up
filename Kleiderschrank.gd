extends Node2D

signal changed_color

const assetRootPath = 'res://assets/wardrobe'
var currentCategory : TextureRect = null
var availableColors = ['blue', 'orange', 'green', 'red', 'pink']
var currentColor = {
	'colorName': 'blue',
	'colorIndex': 0
}

onready var contextualButtons = {
	'back': $ContextualButtons/ButtonBack,
	'color': $ContextualButtons/ButtonColor
}
onready var home = $Home
onready var sidebar = $Sidebar


func _ready():
	closeWardrobe()
	

func closeWardrobe():
	contextualButtons.back.hide()
	contextualButtons.color.hide()
	home.show()
	sidebar.hide()
	
	if currentCategory:
		currentCategory.hide()
		

func openWardrobe(category):
	home.hide()
	sidebar.show()
	
	var newCategory = get_node('Categories/%s' % category)
	
	load_category(newCategory)
	currentCategory = newCategory


func _on_Button_Back_pressed():
	closeWardrobe()


func update_color(idx):
	currentColor.colorIndex = idx
	currentColor.colorName = availableColors[idx]
	emit_signal("changed_color", currentColor.colorName)


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
			categoryItem.texture_normal = getColorTexture(category.get_name().to_lower(), currentColor.colorName, itemName)
		else:
			categoryItem.texture_normal = getTexture(category.get_name().to_lower(), itemName)
			
		category.show()
		contextualButtons.color.hide()
		contextualButtons.back.show()
	
	if category.isColored:
		contextualButtons.color.show()


func _on_ButtonColor_pressed():
	var nextIndex = currentColor.colorIndex + 1
		
	if nextIndex <= (len(availableColors) - 1):
		update_color(nextIndex)
	else: 
		update_color(0)

	load_category()
