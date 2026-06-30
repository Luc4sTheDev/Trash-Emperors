extends Button

@export var dados_caminhao: SkinData
@onready var nome_caminhao: Label = $NomeCaminhao
@onready var cadeado: Sprite2D = $Cadeado
@onready var preco: Label = $Preco


func _ready() -> void:
	expand_icon = true
	atualizar_visual_botao() 

func atualizar_visual_botao() -> void:
	icon = dados_caminhao.icone_loja
	nome_caminhao.text = dados_caminhao.nome_da_skin
	
	if dados_caminhao.esta_desbloqueada:
		cadeado.hide()
		preco.hide() 
	else:
		cadeado.show()
		preco.show()
		preco.text = " " + str(dados_caminhao.preco)

func _on_pressed():
	if dados_caminhao.esta_desbloqueada:
		InventarioGlobal.equipar_skin(dados_caminhao)
		print("Caminhão equipado!")
	else:
		if PontosGlobal.get_points() >= dados_caminhao.preco:
			PontosGlobal.add_points(-dados_caminhao.preco) 
			dados_caminhao.esta_desbloqueada = true
			print("Caminhão comprado!")
			atualizar_visual_botao()
			InventarioGlobal.equipar_skin(dados_caminhao)
			ResourceSaver.save(dados_caminhao, dados_caminhao.resource_path)
		else:
			print("Não tem dinheiro")
