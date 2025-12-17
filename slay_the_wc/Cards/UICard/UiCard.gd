extends AspectRatioContainer
class_name UiCard

@export var data: CardData

const LABEL_CHANGED_COLOR = Color(0.192, 0.51, 1.0)

func _ready() -> void:
	#%NameScroll.get_v_scroll_bar().mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	#%NameScroll.get_h_scroll_bar().mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	#%DescriptionScroll.get_v_scroll_bar().mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	#%DescriptionScroll.get_h_scroll_bar().mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	if data:
		loadCardData(data)
	_on_resized()


func _process(_delta: float) -> void:
	pass


func _on_resized() -> void:
	%CostLabel.pivot_offset = Vector2(0, %CostLabel.size.y)
	resizeLabel(%CostLabel, 45)
	resizeLabel(%Name, 35)
	resizeLabel(%Description, 25)
	# reposition cost pivot to the bottom

func resizeLabel(label: RichTextLabel, base_font_size: int) -> void:
	# scale label fonts
	var new_scale = self.size.x / 500;
	var new_font_size = int(base_font_size*new_scale)
	label.add_theme_font_size_override("normal_font_size", new_font_size)
	label.add_theme_font_size_override("bold_font_size", new_font_size)
	label.add_theme_font_size_override("bold_italics_font_size", new_font_size)
	label.add_theme_font_size_override("italics_font_size", new_font_size)
	label.add_theme_font_size_override("mono_font_size", new_font_size)

func loadCardData(new_data: CardData):
	data = new_data
	updateData()

func updateData():
	%Name.text = data.card_name
	%Description.text = data.description
	%CardIllustration.texture = data.icon
	%CardBg.texture = data.background
	update_mana_cost()

func update_mana_cost():
	%CostLabel.text = str(data.mana_cost - data.mana_cost_reduction)
	var label_color = Color.WHITE if data.mana_cost_reduction == 0 else LABEL_CHANGED_COLOR
	%CostLabel.add_theme_color_override("default_color", label_color)
	
func apply_mana_cost_reduction(reduction: int):
	data.mana_cost_reduction = reduction
	update_mana_cost()

func _on_timer_timeout() -> void:
	self.size += Vector2(10, 10)
	#self.custom_minimum_size += Vector2(10, 10)
