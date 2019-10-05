extends MarginContainer

const PURCHASE_PROCESSING = "Dein Kauf wird bearbeitet..."

var InAppStore = Engine.get_singleton("InAppStore")
var selectedProduct

onready var sceneRoot : MarginContainer = get_tree().get_root().get_node('Main')
onready var clickSfx = Elements.sfx.click
onready var button_list = $StoreWrapper/StoreRect/Container/ButtonsContainer
onready var dialogSettings = Elements.dialogSettings
onready var categories = Elements.categories
onready var dialogInfo = Elements.infoDialog
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
			Events.emit_signal("loading_start", PURCHASE_PROCESSING)
			timer.start()
		else:
			selectedProduct = ''
			Events.emit_signal("loading_end")
			self.hide()


func _check_events():
	while InAppStore.get_pending_event_count() > 0:
		var event = InAppStore.pop_pending_event()

		if event.type == "purchase":
			if event.result == "ok":
				_save_bought_product(selectedProduct)
				_rerender_items()

				selectedProduct = ''
				Events.emit_signal("loading_end")
				self.hide()
			else:
				selectedProduct = ''
				Events.emit_signal("loading_end")
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