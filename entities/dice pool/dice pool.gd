@tool
class_name DicePool extends Node3D


@onready var dice_scene = preload("res://entities/dice/dice.tscn")

@export var dice_counter: int = 5
@export var dimensions: Vector3 = Vector3(20, 14, 20):
	set(dimensions_):
		dimensions = dimensions_
		%Planes.position.y = dimensions.y * 0.5
		$Dices.position.y = dimensions.y * 0.33
		
		for plane in %Planes.get_children():
			plane.dimensions = dimensions

var start_slots: = []


func _ready() -> void:
	init_slots()
	var options = []
	
	for _i in dice_counter:
		if options.is_empty():
			if start_slots.is_empty():
				pass
			
			options = start_slots.pop_front()
		
		var dice = dice_scene.instantiate()
		%Dices.add_child(dice)
		var slot = options.pop_back()
		dice.position = Vector3(slot.x, 0, slot.y) * dimensions
	
	for dice in %Dices.get_children():
		dice._roll()
	
func init_slots() -> void:
	var slot = Vector2.ZERO
	start_slots.append([slot])
	start_slots.append(Global.dict.direction.linear2)
	start_slots.append(Global.dict.direction.diagonal)
