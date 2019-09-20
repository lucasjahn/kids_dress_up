extends TextureButton

# warning-ignore:unused_class_variable
var isActive = false
# warning-ignore:unused_class_variable
var isPictureLoaded = false

var defaultPosition : Vector2
var defaultScale : Vector2
var defaultCharacterScale : Vector2
var defaultCharacterPosition : Vector2

onready var characterNode = $Figur

func _ready():
	defaultPosition = Vector2(self.rect_position.x, self.rect_position.y)
	defaultScale = Vector2(self.rect_scale.x, self.rect_scale.y)
	
	defaultCharacterScale = Vector2(characterNode.rect_scale.x, characterNode.rect_scale.y)
	defaultCharacterPosition = Vector2(characterNode.rect_position.x, characterNode.rect_position.y)
	
	
func reset():
	self.rect_position = defaultPosition
	self.rect_scale = defaultScale
	
	self.set_custom_minimum_size(Vector2(0,0))
	self.expand = false
	
	characterNode.rect_scale = defaultCharacterScale
	characterNode.rect_position = defaultCharacterPosition