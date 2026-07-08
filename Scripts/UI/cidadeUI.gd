extends Control

@onready var cidade: Label = $Cidade

func _ready() -> void:
	var fase = FaseGlobalIndicador.fase_atual
	if fase != null:
		cidade.text = fase.nome_da_fase
	else:
		cidade.text = "Fase não selecionada"
