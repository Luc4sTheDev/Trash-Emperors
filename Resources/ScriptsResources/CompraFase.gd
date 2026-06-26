extends Button

@export var dados_da_fase:FaseData
@onready var nome_fase: Label = $NomeFase
@onready var cadeado: Sprite2D = $Cadeado
@onready var preco: Label = $Preco

func _ready() -> void:
	expand_icon = true
	atualizar_visual_botao() 

func atualizar_visual_botao() -> void:
	icon = dados_da_fase.icone
	nome_fase.text = dados_da_fase.nome_da_fase
	
	if dados_da_fase.esta_desbloqueada:
		cadeado.hide()
		preco.hide() 
	else:
		cadeado.show()
		preco.show()
		preco.text = " " + str(dados_da_fase.preco)
func _on_pressed():
	if dados_da_fase.esta_desbloqueada:
		get_tree().change_scene_to_packed(dados_da_fase.cena_da_fase)
	else:
		if PontosGlobal.get_points() >= dados_da_fase.preco:
			PontosGlobal.add_points(-dados_da_fase.preco) 
			dados_da_fase.esta_desbloqueada = true
			print("comprou")
			atualizar_visual_botao()
		else:
			print("n tem dinheiro")
