extends AspectRatioContainer
class_name UiCard

@export var data: CardData

var costLabel
var nameLabel
var descriptionLabel
var illustration
var cardBg

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	costLabel = $CardBg/VBoxContainer/HBoxContainer/VBoxContainer/IllustrationControl/CostLabel
	nameLabel = $CardBg/VBoxContainer/HBoxContainer/VBoxContainer/Control/VBoxContainer2/Control/Control2/Name
	descriptionLabel = $CardBg/VBoxContainer/HBoxContainer/VBoxContainer/Control/VBoxContainer2/Control2/Control2/Description
	illustration = $CardBg/VBoxContainer/HBoxContainer/VBoxContainer/IllustrationControl/CardIllustration
	cardBg = $CardBg
	if data:
		nameLabel.text = data.card_name
		costLabel.text = str(data.mana_cost)
		descriptionLabel.text = data.description
		illustration.texture = data.icon
		cardBg.texture = data.background

func resizeLabel(label: Label, base_font_size: int) -> void:
	# scale label fonts
	var new_scale = self.size.x / 500;
	label.add_theme_font_size_override(
		"font_size",
		int(base_font_size*new_scale)
	)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	resizeLabel(costLabel, 42)
	resizeLabel(nameLabel, 28)
	resizeLabel(descriptionLabel, 21)
	# reposition cost pivot to the bottom
	costLabel.pivot_offset = Vector2(0, costLabel.size.y)

func _on_timer_timeout() -> void:
	#self.size += Vector2(10, 10)
	self.custom_minimum_size += Vector2(10, 10)
