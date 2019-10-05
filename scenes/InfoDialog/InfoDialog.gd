extends MarginContainer


const SPINNER_SPACING: = 400

onready var labelContainer: MarginContainer = $CenterContainer/DialogBackground/CenterContainer/LabelContainer
onready var label: Label = labelContainer.get_node("Label")
onready var loadingSpinner: AnimatedSprite = $CenterContainer/DialogBackground/LoadingSpinner


func _ready():
	Events.connect("show_info_dialog", self, "_on_show_info_dialog")
	Events.connect("hide_info_dialog", self, "_on_hide_info_dialog")


func _on_show_info_dialog(infoText:= '', showLoadingSpinner: = false):
	var marginTop = 0
	
	label.text = infoText
	loadingSpinner.visible = showLoadingSpinner
	
	if showLoadingSpinner == true:
		marginTop = SPINNER_SPACING
	
	labelContainer.set("custom_constants/margin_top", marginTop)
	
	self.show()


func _on_hide_info_dialog():
	loadingSpinner.hide()
	
	self.hide()