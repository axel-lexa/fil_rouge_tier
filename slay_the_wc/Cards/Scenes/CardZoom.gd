extends CanvasLayer

const POP_DURATION = 0.15

func _ready():
	visible = false

func show_card(data: CardData):
	if !data.illustration_hd:
		return
	visible = true
	$HDCardImage.texture = data.illustration_hd  # toute la carte déjà “prête”
	var screen_size = get_viewport().get_visible_rect().size

	# Limites max pour la carte HD
	var max_width = screen_size.x * 0.2
	var max_height = screen_size.y * 0.4

	# Taille originale de la texture
	var tex_size = data.illustration_hd.get_size()
	var aspect = tex_size.x / tex_size.y
	
	# Calcul du scale proportionnel pour ne pas dépasser les limites
	var scale_x = min(max_width / tex_size.x, max_height / tex_size.y)
	var scale_y = scale_x  # garder le ratio
	
	# Commence minuscule pour l’animation pop
	$HDCardImage.scale = Vector2(0, 0)

	# Positionner au centre
	#$HDCardImage.position = (screen_size - tex_size * scale_x) / 2
	$HDCardImage.position = Vector2(0, 0)

	# Tween pour animation pop
	create_tween().tween_property($HDCardImage, "scale", Vector2(scale_x, scale_y), POP_DURATION)
	
func hide_card():
	visible = false
