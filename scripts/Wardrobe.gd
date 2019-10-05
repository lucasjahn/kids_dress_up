extends MarginContainer

signal closed
signal opened

const assetRootPath = 'res://assets/wardrobe'
var currentCategory = null
var currentColor = 'blue'

onready var contextualButtons : Dictionary = {
	'back': Elements.buttonBack,
	'color': Elements.buttonPickColor,
	'delete': Elements.buttonDelete,
	'lookbook': Elements.buttonSaveToLookbook
}
onready var wardrobeMenu = Elements.wardrobeMenu
onready var openWardrobeNode = Elements.wardrobe.get_node('OpenWardrobeContainer')
onready var clickSfx = Elements.sfx.click
onready var colorPickerScene = Elements.colorPicker


func _ready():
	Events.connect("category_selected", self, "openWardrobe")
	Events.connect("color_picked", self, "_on_ColorPicker_color_selected")
	Events.connect("open_color_picker_clicked", self, "_on_ButtonColor_pressed")

	closeWardrobe()


func closeWardrobe():
	contextualButtons.back.hide()
	contextualButtons.color.hide()
	wardrobeMenu.show()
	openWardrobeNode.hide()

	if currentCategory:
		currentCategory.hide()

	emit_signal("closed")


func openWardrobe(category):
	wardrobeMenu.hide()
	openWardrobeNode.show()

	if Elements.categories.has_node(category):
		var newCategory = Elements.categories.get_node(category)

		load_category(newCategory)
		currentCategory = newCategory

		emit_signal("opened")


func _on_Button_Back_pressed():
	clickSfx.pitch_scale = 1
	clickSfx.play(0)
	closeWardrobe()


func update_color(colorName):
	currentColor = colorName


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
