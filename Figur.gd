extends Sprite

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
		
		targetNode.show()
		dressedItems[categoryName] = targetNode

func _on_item_pressed(category, itemName):
	toggleItemVisability(category, itemName)
