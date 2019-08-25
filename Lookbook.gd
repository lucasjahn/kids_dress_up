extends Node2D

signal backToHome

var lookbook = []
var lookbookFilePath = "user://lookbook.save"
var activePicture = null

onready var pictureFrames = $PictureFrames
onready var dialgConfirmationDelete = $DialogConfirmationDelete
onready var header = $Header
onready var deleteButton = $Header/ButtonDelete
onready var background = $Background
onready var pictureDetailControls = $PictureDetailControls
onready var dialogConfirmationDeleteDetail = $DialogConfirmationDeleteDetail
onready var clickSfx = $Click

func _ready():
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
		
	lookbookFile.open(lookbookFilePath, File.READ)
	
	var lookbookData = parse_json(lookbookFile.get_as_text())
	
	lookbookFile.close()
	
	if typeof(lookbookData) == TYPE_ARRAY:
		lookbook = lookbookData
	else:
		lookbook = []
	
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
	if node.isPictureLoaded:
		node.isActive = true
		activePicture = index
		
		for pictureFrame in pictureFrames.get_children():
			if not pictureFrame.isActive:
				pictureFrame.hide()
				
		header.hide()
		background.rect_scale.y = 1.44
		
		node.rect_position.x = 652
		node.rect_position.y = 219
		
		node.rect_scale.x = 1.25
		node.rect_scale.y = 1.25
		
		playClick()
		pictureDetailControls.show()


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
	pictureDetailControls.hide()
	background.reset()
		

func _on_DialogConfirmationDeleteDetail_dialog_confirmed(status):
	if status:	
		deleteDetail()
		_on_ButtonBack_pressed()
		
	playClick()
	dialogConfirmationDeleteDetail.hide()
