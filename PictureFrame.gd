extends TextureButton

# warning-ignore:unused_class_variable
var isActive = false
# warning-ignore:unused_class_variable
var isPictureLoaded = false

var defaultPosition : Vector2
var defaultScale : Vector2

func _ready():
	defaultPosition.x = self.rect_position.x
	defaultPosition.y = self.rect_position.y
	
	defaultScale.x = self.rect_scale.x
	defaultScale.y = self.rect_scale.y
	
func reset():
	self.rect_position.x = defaultPosition.x
	self.rect_position.y = defaultPosition.y
	
	self.rect_scale.x = defaultScale.x
	self.rect_scale.y = defaultScale.y