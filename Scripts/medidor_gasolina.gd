class_name GasUI
extends Control

@onready var gasolina_ui: ProgressBar = $GasolinaUI

@export var truck_path: NodePath
var truck_class: Caminhao_Lixo


func _ready() -> void:
	truck_class = get_node(truck_path)
	truck_class.gas_change.connect(update_gas)

	gasolina_ui.max_value = truck_class.gas_max
	gasolina_ui.value = truck_class.current_gas


func update_gas(new_gas: float):
	gasolina_ui.value = new_gas
