extends Node


# Action
signal color_picked(colorName)
signal mute_clicked
signal character_selected(characterName)
signal reset_character_selection
signal delete_clothes_confirmed
signal clothes_selected(category, itemName, isStackable)
signal lookbook_is_full

signal show_info_dialog(infoText, showLoadingSpinner)
signal hide_info_dialog


# Navigation
signal home_clicked
signal open_lookbook_clicked
signal category_selected(selectedCategory)
signal open_color_picker_clicked