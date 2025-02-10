extends Node
class_name cmp_Inventory

signal ON_ItemAdded(item: Resource, amount: int)

var inventory={}

func __AddItem(item: Resource, amount: int):
	inventory[item]=__GetItemAmount(item)+amount
	ON_ItemAdded.emit(item,amount)

func __GetItemAmount(item: Resource)-> int:
	return inventory.get(item,0)

