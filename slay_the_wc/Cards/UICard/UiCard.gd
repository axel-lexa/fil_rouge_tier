extends AspectRatioContainer
class_name UiCard

@export var data: CardData

func _ready() -> void:
	if data:
		loadCardData(data)

func _process(_delta: float) -> void:
	resizeLabel(%CostLabel, 45)
	resizeLabel(%Name, 35)
	resizeLabel(%Description, 30)
	# reposition cost pivot to the bottom
	%CostLabel.pivot_offset = Vector2(0, %CostLabel.size.y)

func resizeLabel(label: Label, base_font_size: int) -> void:
	# scale label fonts
	var new_scale = self.size.x / 500;
	label.add_theme_font_size_override(
		"font_size",
		int(base_font_size*new_scale)
	)

func loadCardData(new_data: CardData):
	%Name.text = new_data.card_name
	%CostLabel.text = str(new_data.mana_cost)
	%Description.text = new_data.description
	%CardIllustration.texture = new_data.icon
	%CardBg.texture = new_data.background
	

func _on_timer_timeout() -> void:
	#self.size += Vector2(10, 10)
	self.custom_minimum_size += Vector2(10, 10)
