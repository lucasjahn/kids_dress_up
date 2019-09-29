extends Node2D

signal delete_item



func _ready():
	if get_parent().isTouchable:
		for child in get_children():
			child.connect("pressed", self, "_on_buttonPressed", [self, child.get_name()])
		
		
func _on_buttonPressed(category, itemName):
	emit_signal("delete_item", category, itemName, true)


onready var animation = $SparkleAnimation
onready var sparkle = $Sparkle
onready var dress = $Dresses/Dress1



func _on_Dress1_pressed():
	
	animation.play()
	print("yes")