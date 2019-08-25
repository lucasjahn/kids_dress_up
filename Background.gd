extends TextureRect

var defaultScale : Vector2

func _ready():
	defaultScale.x = self.rect_scale.x
	defaultScale.y = self.rect_scale.y
	
func reset():
	self.rect_scale.x = defaultScale.x
	self.rect_scale.y = defaultScale.y