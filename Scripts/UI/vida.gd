extends Control

@onready var vida_label: Label = $vidaLabel

@export var truck_path:NodePath
var truck_class:Caminhao_Lixo


func _ready() -> void:
	truck_class = get_node(truck_path)
	truck_class.life_change.connect(update_life)
	update_life(truck_class.vida)


func update_life(new_life: int):
	vida_label.text = " " + str(new_life)
