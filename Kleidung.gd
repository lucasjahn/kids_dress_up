extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func toggleNodeVisability(nodeName):
	var targetNode = get_node(nodeName)
	
	if targetNode.visible:
		targetNode.hide()
	else:
		targetNode.show()

func _on_B_Kleid_Gelb_pressed():
	toggleNodeVisability("B Kleid Gelb/Kleid Gelb")

func _on_B_Kleid_Green_pressed():
	toggleNodeVisability("B Kleid Green/Kleid Green")
