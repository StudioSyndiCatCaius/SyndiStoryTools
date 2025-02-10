extends Node
class_name cmp_Equipment



var equipment={}

func __EquipItem(slot: Resource, item: Resource):
	__UnequipSlot(slot)
	equipment[slot]=item
	pass

func __UnequipSlot(slot: Resource):
	equipment[slot]=null
	pass
