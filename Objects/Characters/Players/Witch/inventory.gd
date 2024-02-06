extends Node

@export var items:Array[InventoryItem]
var currently_selected_index:int = 0

func add_item_to_current_slot(new_item:InventoryItem):
	if (currently_selected_index < 0 || currently_selected_index >= items.size()):
		push_error("Error trying to access inventory item at index %d. Currently selected index out of bounds." % currently_selected_index)
		return false
	if (items[currently_selected_index] != null):
		return false
	items[currently_selected_index] = new_item
	print(as_string())
	return true
	
func get_item(index:int):
	if (index < 0 || index >= items.size()):
		push_error("Error trying to access inventory item at index %d. Index out of bounds." % index)
		return null
	return items[index]

func _input(event:InputEvent):
	if (event.is_action_pressed("inventory_cycle_down")):
		currently_selected_index = (currently_selected_index - 1) % items.size()
		return

	if (event.is_action_pressed("inventory_cycle_up")):
		currently_selected_index = (currently_selected_index + 1) % items.size()
		return

func withdraw_current_item():
	print(as_string())
	
	if (currently_selected_index < 0 || currently_selected_index >= items.size()):
		push_error("Error trying to access inventory item at index %d. Currently selected index out of bounds." % currently_selected_index)
		return null
	if (items[currently_selected_index] == null):
		return null
	var current_item:InventoryItem = items[currently_selected_index]
	items[currently_selected_index] = null
	return current_item

func as_string():
	var result:String = ""
	for i:int in range(0, items.size()):
		if (i == currently_selected_index):
			result += "["
		result += items[i].display_name if items[i] != null else "None"
		if (i == currently_selected_index):
			result += "]"
		result += " "
	return result
