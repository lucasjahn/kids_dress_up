extends TextureRect

const ASSET_ROOT_PATH = 'res://assets/wardrobe'

var dressedItems = {
	'Shoes': null,
	'Pants': null,
	'Dresses': null,
	'Tops': null,
	'Shorts': null,
	'Pullover': null,
	'Special': null,
	'Stack': [],
}

# warning-ignore:unused_class_variable
export var isTouchable = false

onready var plopSfx = $Plop
onready var shutterSfx = $Shutter
onready var clickSfx = Elements.sfx.click
onready var deleteConfirmationScene = Elements.dialogConfirmationDelete
onready var deleteButton = Elements.buttonDelete
onready var addToLookbookButton = Elements.buttonSaveToLookbook
onready var openLookbookButton = Elements.buttonLookbook
onready var wardrobeHome = Elements.wardrobeMenu
onready var pictureFrameWrapper = Elements.animatedPictureFrame
onready var pictureFrame = pictureFrameWrapper.get_node('Node2D/PictureFrame')
onready var pictureFrameAnimation = pictureFrameWrapper.get_node('Node2D/PictureFrame/Animation')

func _ready():
	Events.connect("clothes_selected", self, "toggleItemVisability")

	if deleteConfirmationScene:
		Events.connect("delete_clothes_confirmed", self, "_on_deleteConfirmation_confirmed")

	if wardrobeHome:
		Events.connect("reset_character_selection", self, "resetClothes")


func resetClothes():
	for category in dressedItems:
		if dressedItems[category]:
			if not category == 'Stack':
				dressedItems[category].hide()
				dressedItems[category] = null
			else:
				for stackItem in dressedItems[category]:
					stackItem.node.hide()
					
				dressedItems[category] = []


func getTexture(category, itemName):
	return load("%s/%s/%s.png" % [ASSET_ROOT_PATH, category, itemName])


func getColorTexture(category, color, itemName):
	return load("%s/%s/%s/%s.png" % [ASSET_ROOT_PATH, category, color, itemName])


func _getStackItemIndex(itemName) -> int:
	var returnIndex = -1 
	
	if not len(dressedItems['Stack']):
		return returnIndex
	else:
		for index in len(dressedItems['Stack']):
			if dressedItems['Stack'][index].itemName == itemName:
				returnIndex = index
				
		return returnIndex


func toggleItemVisability(category, itemName, shouldDelete = false, isStackable: = false):
	var activeWardrobeColor = get_tree().get_root().get_node('Main').activeWardrobeColor
	var categoryName = category.get_name()
	var targetNode = get_node('%s/%s' % [categoryName, itemName])
	var dressedItem = null if isStackable else dressedItems[categoryName]
	var dressedStackItemIndex = _getStackItemIndex(itemName)
	var targetTexture = null

	if category.get("isColored") and category.isColored:
		targetTexture = getColorTexture(categoryName.to_lower(), activeWardrobeColor, itemName.to_lower())
	else:
		targetTexture = getTexture(categoryName.to_lower(), itemName.to_lower())

	if shouldDelete or (not isStackable && dressedItem && targetTexture.resource_path == dressedItem.texture_normal.resource_path):
		targetNode.hide()
		dressedItems[categoryName] = null
	elif isStackable and dressedStackItemIndex > -1:
		targetNode.hide()
		dressedItems['Stack'].remove(dressedStackItemIndex)
	else:
		if dressedItem:
			dressedItem.hide()

		targetNode.texture_normal = targetTexture

		plopSfx.play(0)
		targetNode.show()

		deleteButton.show()
		addToLookbookButton.show()

		if isStackable:
			dressedItems['Stack'].append({
				"itemName": itemName,
				"node": targetNode
			})
		else:
			dressedItems[categoryName] = targetNode

	#TODO REFACTOR!
	var isNaked = true

	for category in dressedItems:
		if dressedItems[category]:
			isNaked = false

	if isNaked:
		deleteButton.hide()
		addToLookbookButton.hide()


func showItemTexture(category, targetNodeName, texturePath):
	var targetNode = get_node(targetNodeName)

	targetNode.texture_normal = load(texturePath)
	targetNode.show()

	if category == 'Stack':
		dressedItems['Stack'].append({
			"itemName": targetNode.get_name(),
			"node": targetNode
		})
	else:
		dressedItems[category] = targetNode


func _on_item_pressed(category, itemName):
	toggleItemVisability(category, itemName)

func _on_deleteConfirmation_confirmed(status):
	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)

	if status:
		resetClothes()
		deleteButton.hide()
		addToLookbookButton.hide()

	deleteConfirmationScene.hide()

func _on_ButtonDelete_pressed():
	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)

	deleteConfirmationScene.show()

func load_lookbook():
	var lookbookFile = File.new()
	var lookbookFilePath = "user://lookbook.save"

	if not lookbookFile.file_exists(lookbookFilePath):
        return null

	lookbookFile.open(lookbookFilePath, File.READ)

	var lookbookData = parse_json(lookbookFile.get_as_text())

	lookbookFile.close()

	if typeof(lookbookData) == TYPE_ARRAY:
		return lookbookData

	return null


func save_to_lookbook():
	var saveLookbook = File.new()
	var lookbookData = load_lookbook() if load_lookbook() else []

	if len(lookbookData) == 3:
		Events.emit_signal("lookbook_is_full")
		return

	var lookbookItem = {
		"character": self.texture.resource_path,
		"dressedItems": {}
	}

	for category in dressedItems:
		if dressedItems[category]:
			if not category == 'Stack':
				var texturePath = dressedItems[category].texture_normal.resource_path
				var nodePath = "%s/%s" % [category, dressedItems[category].get_name()]
	
				lookbookItem.dressedItems[category] =  {
					"nodePath": nodePath,
					"texturePath": texturePath
				}
			else:
				lookbookItem.dressedItems['Stack'] = []
				
				if len(dressedItems[category]) > 0:
					for stackItem in dressedItems[category]:
						var texturePath = stackItem.node.texture_normal.resource_path
						var nodePath = "%s/%s" % ['Special', stackItem.node.get_name()]
			
						lookbookItem.dressedItems['Stack'].append({
							"nodePath": nodePath,
							"texturePath": texturePath
						})
					

	lookbookData.append(lookbookItem)
	saveLookbook.open("user://lookbook.save", File.WRITE)

	var lookbookDataJson = to_json(lookbookData)
	saveLookbook.store_string(lookbookDataJson)
	saveLookbook.close()

	shutterSfx.play()

	_duplicate_character(self, pictureFrame)

	openLookbookButton.load_texture(len(lookbookData))

	pictureFrameWrapper.show()
	pictureFrameAnimation.play("PictureFrameAnimation")


func _duplicate_character(currentNode, targetNode):
	var characterDuplicate = currentNode.duplicate()
	var existingCharacter = targetNode.get_node('Character') if targetNode.has_node('Character') else null

	if existingCharacter:
		targetNode.remove_child(existingCharacter)
		existingCharacter.queue_free()

	characterDuplicate.rect_position = Vector2(203, 123)
	characterDuplicate.rect_scale = Vector2(0.4, 0.4)

	targetNode.add_child(characterDuplicate)
