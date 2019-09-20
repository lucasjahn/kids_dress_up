extends MarginContainer

signal backToHome

var lookbook = []
var lookbookFilePath = "user://lookbook.save"
var activePicture = null
var buttonTextures = []

var scaleFactor = 1.3

onready var pictureFrames = $VBoxContainer/PictureFrameWrapper/PictureFrames
onready var dialgConfirmationDelete = $DialogConfirmationDelete
onready var header = $VBoxContainer/Header
onready var deleteButton = $VBoxContainer/Header/ButtonRightContainer/ButtonDelete
onready var pictureDetailHeaderControls = $VBoxContainer/PictureDetailHeaderControls
onready var pictureDetailFooterControls = $VBoxContainer/PictureDetailFooterControls
onready var buttonBack = $VBoxContainer/PictureDetailHeaderControls/ButtonLeftContainer/ButtonBack
onready var dialogConfirmationDeleteDetail = $DialogConfirmationDeleteDetail
onready var clickSfx = $Click
onready var addToLookbookButton = get_parent().get_node('MainSceneContainer/ButtonLeftContainer/VBoxContainer/ButtonsBottom/ButtonOpenLookbook') if get_parent().has_node('MainSceneContainer/ButtonLeftContainer/VBoxContainer/ButtonsBottom/ButtonOpenLookbook') else null

func _ready():
	buttonTextures = [
		preload("res://assets/btn_lookbook_small.png"),
		preload("res://assets/btn_lookbook_small_1.png"),
		preload("res://assets/btn_lookbook_small_2.png"),
		preload("res://assets/btn_lookbook_small_3.png"),
	]
	
	load_lookbook()
	render_looks()
	
	
func playClick(pitch = 0.7):
	clickSfx.pitch_scale = pitch
	clickSfx.play(0)
	
func _on_ButtonHome_pressed():
	emit_signal("backToHome")

func load_lookbook():
	var lookbookFile = File.new()
    
	if not lookbookFile.file_exists(lookbookFilePath):
		lookbook = []
	else:
		lookbookFile.open(lookbookFilePath, File.READ)
		
		var lookbookData = parse_json(lookbookFile.get_as_text())
		
		lookbookFile.close()
		
		if typeof(lookbookData) == TYPE_ARRAY:
			lookbook = lookbookData
		else:
			lookbook = []
		
	var lookbookLength = len(lookbook)
	
	addToLookbookButton.load_texture(lookbookLength)
	buttonBack.texture_normal = buttonTextures[lookbookLength]
	
func render_looks():
	var pictureSingleFrames = pictureFrames.get_children()
	
	for pictureFrame in pictureSingleFrames:
		pictureFrame.get_child(0).hide()
		pictureFrame.isPictureLoaded = false
		deleteButton.hide()
		
	if len(lookbook) > 0:
		var counter = 0
		
		for lookbookItem in lookbook:
			if counter <= len(pictureSingleFrames) - 1:
				var pictureFrameNode = pictureSingleFrames[counter]
				var characterNode = pictureFrameNode.get_child(0)
				
				if lookbookItem.character:
					characterNode.texture = load(lookbookItem.character)
					
				if lookbookItem.dressedItems:
					var dressedItems = lookbookItem.dressedItems
					
					characterNode.resetClothes()
					
					for categoryItem in dressedItems:
							characterNode.showItemTexture(categoryItem, dressedItems[categoryItem].nodePath, dressedItems[categoryItem].texturePath)
					
				characterNode.show()
				pictureFrameNode.isPictureLoaded = true
				
				
			counter += 1
		
		deleteButton.show()
			
			
func resetLookbook():
	var lookbookFile = File.new()
	lookbookFile.open(lookbookFilePath, File.WRITE)
	
	lookbookFile.store_string(' ')
	lookbookFile.close()
	
	_ready()


func _on_ButtonDelete_pressed():
	playClick()
	dialgConfirmationDelete.show()

func _on_DialogConfirmationDelete_dialog_confirmed(status):
	if status:	
		resetLookbook()
		
	playClick()
	dialgConfirmationDelete.hide()
	
	
func showPictureDetail(node, index):
	var characterNode = node.get_node('Figur')
	
	if node.isPictureLoaded and not node.isActive:
		node.isActive = true
		activePicture = index
		
		for pictureFrame in pictureFrames.get_children():
			if not pictureFrame.isActive:
				pictureFrame.hide()
				
		node.set_custom_minimum_size(Vector2(node.rect_size.x*scaleFactor, node.rect_size.y*scaleFactor))
		node.expand = true
		
		characterNode.rect_scale = Vector2(characterNode.rect_scale.x*scaleFactor, characterNode.rect_scale.y*scaleFactor)
		characterNode.rect_position = Vector2(characterNode.rect_position.x*scaleFactor, characterNode.rect_position.y*scaleFactor)
		
		header.hide()
		
		playClick()
		pictureDetailHeaderControls.show()
		pictureDetailFooterControls.show()


func _on_ButtonDeleteDetail_pressed():
	playClick()
	dialogConfirmationDeleteDetail.show()
	
	
func deleteDetail():
	if not activePicture == null:
		var lookbookFile = File.new()
		
		lookbook.remove(activePicture)
		
		lookbookFile.open(lookbookFilePath, File.WRITE)
		lookbookFile.store_string(to_json(lookbook))
		lookbookFile.close()
	
		_ready()


func _on_ButtonBack_pressed():
	playClick(1)
	activePicture = null
	
	for pictureFrame in pictureFrames.get_children():
		if pictureFrame.isActive:
			pictureFrame.isActive = false
			pictureFrame.reset()
		
		pictureFrame.show()
	
	header.show()
	pictureDetailHeaderControls.hide()
	pictureDetailFooterControls.hide()
		

func _on_DialogConfirmationDeleteDetail_dialog_confirmed(status):
	if status:	
		deleteDetail()
		_on_ButtonBack_pressed()
		
	playClick()
	dialogConfirmationDeleteDetail.hide()
