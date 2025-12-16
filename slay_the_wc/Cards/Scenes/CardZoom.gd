extends CanvasLayer

const POP_DURATION = 0.15
const POP_BACK_DURATION = 0.05

var lastData: CardData

var debounceHideTimer: Timer = Timer.new()

func _ready():
	add_child(debounceHideTimer)
	debounceHideTimer.wait_time = 0.5
	debounceHideTimer.one_shot = true
	debounceHideTimer.timeout.connect(func (): 
		create_tween().tween_property(%ResizeControl, "custom_minimum_size", Vector2(0, 0), POP_BACK_DURATION)
		lastData = null
	)
	visible = false
	%UiCard.get_node("%NameScroll").get_v_scroll_bar().mouse_filter = VScrollBar.MouseFilter.MOUSE_FILTER_IGNORE
	%UiCard.get_node("%DescriptionScroll").get_v_scroll_bar().mouse_filter = VScrollBar.MouseFilter.MOUSE_FILTER_IGNORE
	#$DebugTimer.start()

func show_card(data: CardData):
	if !data.background:
		return
	visible = true
	var screen_size = get_viewport().get_visible_rect().size
	# Limites max pour la carte HD
	var max_height = screen_size.y * 0.6
	var max_width = max_height * %UiCard.ratio

	debounceHideTimer.stop()
	if (!lastData || data.id != lastData.id):
		print(data.id)
		if (lastData):
			print(lastData.id)
		%UiCard.loadCardData(data)
		%ResizeControl.custom_minimum_size = Vector2(0, 0)
		# Tween pour animation pop
		create_tween().tween_property(%ResizeControl, "custom_minimum_size", Vector2(max_width, max_height), POP_DURATION)
		lastData = data

func hide_card():
	debounceHideTimer.start()

# keep displaying when mouse hover the zoomed card to be able to scroll card labels
func _on_ui_card_mouse_entered() -> void:
	debounceHideTimer.stop()
	#$DebugTimer.stop()
func _on_ui_card_mouse_exited() -> void:
	debounceHideTimer.start()
	#$DebugTimer.start()


func _on_timer_timeout() -> void:
	show_card(load("res://slay_the_wc/Cards/Data/Aixasperants/brasier_solaire.tres"))
	hide_card()
