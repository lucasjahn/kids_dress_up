extends MarginContainer

var InAppStore = Engine.get_singleton("InAppStore")
var selectedProduct

onready var sceneRoot : MarginContainer = get_tree().get_root().get_node('Main')
onready var clickSfx = sceneRoot.get_node('Sfx/Click')
onready var button_list = $StoreWrapper/StoreRect/Container/ButtonsContainer
onready var dialogSettings = sceneRoot.get_node('DialogSettings')
onready var categories = sceneRoot.get_node('MainSceneContainer/Wardrobe/OpenWardrobeContainer/OpenWardrobeCols/OpenWardrobe/CenterContainer/ScrollContainer/MarginContainer/Categories')
onready var timer = $Timer

func _ready():
	timer.connect("timeout", self, "_check_events")

	for button in button_list.get_children():
		var buttonNode = button.get_child(0)
		buttonNode.connect('pressed', self, '_on_buy_clicked', [buttonNode.product_id])


func _on_buy_clicked(product_id):
	selectedProduct = product_id

	self.hide()
	dialogSettings.open_scene(true, 'Store')


func _rerender_items():
	for category in categories.get_children():
		category.load_and_resize_items(false)


func buy_item():
	if selectedProduct:
		var result = InAppStore.purchase( { "product_id": selectedProduct } )

		if result == OK:
			timer.start()
		else:
			selectedProduct = ''
			self.hide()


func _check_events():
	while InAppStore.get_pending_event_count() > 0:
		var event = InAppStore.pop_pending_event()

		if event.type == "purchase":
			if event.result == "ok":
				_save_bought_product(selectedProduct)
				_rerender_items()

				selectedProduct = ''
				self.hide()
			else:
				selectedProduct = ''
				self.hide()

func _on_CloseButton_pressed():
	clickSfx.play(0)
	self.hide()

func _save_bought_product(product_id):
	if product_id:
		var boughtProductsFile = File.new()
		var boughtProducts = load_bought_products() if load_bought_products() else []

		boughtProducts.append(product_id)
		boughtProductsFile.open("user://boughtProducts.save", File.WRITE)

		var boughProductsJson = to_json(boughtProducts)
		boughtProductsFile.store_string(boughProductsJson)
		boughtProductsFile.close()


func load_bought_products():
	var boughtProductsFile = File.new()
	var boughtProductsFilePath = "user://boughtProducts.save"

	if not boughtProductsFile.file_exists(boughtProductsFilePath):
        return null

	boughtProductsFile.open(boughtProductsFilePath, File.READ)

	var products = parse_json(boughtProductsFile.get_as_text())

	boughtProductsFile.close()

	if typeof(products) == TYPE_ARRAY:
		return products

	return null