extends TextureRect

const assetRootPath = 'res://assets/wardrobe'
var dressedItems = {
	'Shoes': null,
	'Pants': null,
	'Dresses': null,
	'Tops': null,
	'Shorts': null,
	'Pullover': null,
	'Special': null
}

onready var plopSfx = $Plop
onready var shutterSfx = $Shutter
onready var clickSfx = get_parent().get_node('Wardrobe/Click') if get_parent().has_node('Wardrobe/Click') else null
onready var deleteConfirmationScene = get_parent().get_node('DialogConfirmationDelete') if get_parent().has_node('DialogConfirmationDelete') else null
onready var deleteButton = get_parent().get_node('Wardrobe/ContextualButtons/ButtonDelete') if get_parent().has_node('Wardrobe/ContextualButtons/ButtonDelete') else null
onready var addToLookbookButton = get_parent().get_node('Wardrobe/ContextualButtons/ButtonSaveToLookbook') if get_parent().has_node('Wardrobe/ContextualButtons/ButtonSaveToLookbook') else null
onready var wardrobe = get_parent().get_node('Wardrobe') if get_parent().has_node('Wardrobe') else null
onready var wardrobeHome = get_parent().get_node('Wardrobe/Home') if get_parent().has_node('Wardrobe/Home') else null

func _ready():
	if deleteConfirmationScene:
		deleteConfirmationScene.connect("dialog_confirmed", self, "_on_deleteConfirmation_confirmed")
		
	if wardrobeHome:
		wardrobeHome.connect("resetCharacterSelection", self, "resetClothes")
	
	if wardrobe:
		wardrobe.connect("save_look", self, "save_to_lookbook")


func resetClothes():
	for category in dressedItems:
		if dressedItems[category]:
			dressedItems[category].hide()
			dressedItems[category] = null


func getTexture(category, itemName):
	return load("%s/%s/%s.png" % [assetRootPath, category, itemName])


func getColorTexture(category, color, itemName):
	return load("%s/%s/%s/%s.png" % [assetRootPath, category, color, itemName])


func toggleItemVisability(category, itemName):
	var activeWardrobeColor = get_parent().activeWardrobeColor
	var categoryName = category.get_name()
	var targetNode = get_node('%s/%s' % [categoryName, itemName])
	var dressedItem = dressedItems[categoryName]
	var targetTexture = null
	
	if category.isColored:
		targetTexture = getColorTexture(categoryName.to_lower(), activeWardrobeColor, itemName.to_lower())
	else: 
		targetTexture = getTexture(categoryName.to_lower(), itemName.to_lower())
	
	if dressedItem && targetTexture.resource_path == dressedItem.texture.resource_path:
		targetNode.hide()
		dressedItems[categoryName] = null
	else:
		if dressedItem:
			dressedItem.hide()
		
		targetNode.texture = targetTexture
		
		plopSfx.play(0)
		targetNode.show()
		
		deleteButton.show()
		addToLookbookButton.show()
		
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
	
	targetNode.texture = load(texturePath)
	targetNode.show()
	
	dressedItems[category] = targetNode


func _on_item_pressed(category, itemName):
	toggleItemVisability(category, itemName)
	
func _on_deleteConfirmation_confirmed(status):
	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)
	
	if status:
		resetClothes()
		deleteButton.hide()
	
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
	var lookbookItem = {
		"character": self.texture.resource_path,
		"dressedItems": {}
	}
	
	for category in dressedItems:
		if dressedItems[category]:
			var texturePath = dressedItems[category].texture.resource_path
			var nodePath = "%s/%s" % [category, dressedItems[category].get_name()]
			
			lookbookItem.dressedItems[category] =  {
				"nodePath": nodePath,
				"texturePath": texturePath
			}
	
	lookbookData.append(lookbookItem)
	saveLookbook.open("user://lookbook.save", File.WRITE)
	
	var lookbookDataJson = to_json(lookbookData)
	saveLookbook.store_string(lookbookDataJson)
	
	shutterSfx.play()
	
	saveLookbook.close()