extends CanvasLayer

@onready var timer_label: Label =   %TimeLabel
@onready var Meat_label: Label =  %MeatLabel
var time_lapsed: float = 0.0
var meat_counter: int = 0


func _ready():
	GameManager.player.meat_collected.connect(on_meat_collected)
	Meat_label.text = str(meat_counter)

func _process(delta:float):
	time_lapsed += delta
	var time_lapsed_in_seconds: int = floori(time_lapsed)
	var seconds: int = time_lapsed_in_seconds % 60
	var minutes: int = time_lapsed_in_seconds / 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	
	#timer_label.text = str(time_lapsed)

func on_meat_collected(reg_value: int) -> void:
	meat_counter += 1
	Meat_label.text = str(meat_counter)
	
