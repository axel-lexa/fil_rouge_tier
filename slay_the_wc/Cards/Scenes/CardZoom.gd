extends CanvasLayer

const POP_DURATION = 0.15

var tween: PropertyTweener
var lastData: CardData

var debounceTimer: Timer = Timer.new()

func _ready():
	add_child(debounceTimer)
	debounceTimer.wait_time = 0.5
	debounceTimer.one_shot = true
	debounceTimer.timeout.connect(_hide)
	visible = false
	$Control/UiCard.alignment_horizontal = HORIZONTAL_ALIGNMENT_LEFT
	$Control/UiCard.get_node("%NameScroll").get_v_scroll_bar().mouse_filter = VScrollBar.MouseFilter.MOUSE_FILTER_IGNORE
	$Control/UiCard.get_node("%DescriptionScroll").get_v_scroll_bar().mouse_filter = VScrollBar.MouseFilter.MOUSE_FILTER_IGNORE

func show_card(data: CardData):
	if !data.background:
		return
	visible = true
	var screen_size = get_viewport().get_visible_rect().size
	# Limites max pour la carte HD
	var max_height = screen_size.y * 0.6
	var max_width = max_height * $Control/UiCard.ratio

	debounceTimer.stop()
	# Tween pour animation pop
	if (!lastData || data.id != lastData.id):
		print(data.id)
		if (lastData):
			print(lastData.id)
		$Control/UiCard.loadCardData(data)
		$Control.size = Vector2(0, 0)
		tween = create_tween().tween_property($Control, "size", Vector2(max_width, max_height), POP_DURATION)
		lastData = data

func hide_card():
	debounceTimer.start()

func _hide():
	visible = false

# keep displaying when mouse hover the zoomed card to be able to scroll card labels
func _on_ui_card_mouse_entered() -> void:
	debounceTimer.stop()
func _on_ui_card_mouse_exited() -> void:
	debounceTimer.start()
