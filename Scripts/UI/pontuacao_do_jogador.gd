extends Label

@onready var pontuacao_do_jogador: Label = $"."

func _ready() -> void:
	pontuacao_do_jogador.text = " " + str(PontosGlobal.get_points())
