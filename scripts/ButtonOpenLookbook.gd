extends TextureButton

onready var animationPlayer = $Animation

var buttonTextures = null

func _ready():
	buttonTextures = [
		preload("res://assets/btn_lookbook_small.png"),
		preload("res://assets/btn_lookbook_small_1.png"),
		preload("res://assets/btn_lookbook_small_2.png"),
		preload("res://assets/btn_lookbook_small_3.png"),
	]

func show_lookbook_full():
	animationPlayer.play("Wobble")
	
func load_texture(count):
	self.texture_normal = buttonTextures[count]