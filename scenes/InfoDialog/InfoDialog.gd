extends MarginContainer


const SPINNER_SPACING: = 400

onready var labelContainer: MarginContainer = $CenterContainer/DialogBackground/CenterContainer/LabelContainer
onready var label: Label = labelContainer.get_node("Label")
onready var loadingSpinner: AnimatedSprite = $CenterContainer/DialogBackground/LoadingSpinner
onready var closeButton: TextureButton = $CenterContainer/DialogBackground/CloseButton


func _ready():
	Events.connect("show_info_dialog", self, "_on_show_info_dialog")
	Events.connect("hide_info_dialog", self, "_on_hide_info_dialog")
	
	closeButton.connect("pressed", self, "_on_hide_info_dialog")


func _on_show_info_dialog(infoText:= '', showLoadingSpinner: = false, isClosable: = true):
	var marginTop = 0
	
	label.text = infoText
	loadingSpinner.visible = showLoadingSpinner
	closeButton.visible = isClosable
	
	if showLoadingSpinner == true:
		marginTop = SPINNER_SPACING
	
	labelContainer.set("custom_constants/margin_top", marginTop)
	
	self.show()


func _on_hide_info_dialog():
	loadingSpinner.hide()
	
	self.hide()