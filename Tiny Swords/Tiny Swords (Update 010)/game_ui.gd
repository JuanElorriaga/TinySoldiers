extends CanvasLayer

@onready var timer_label: Label =   %TimeLabel
@onready var Meat_label: Label =  %MeatLabel




func _process(delta:float):
	timer_label.text = GameManager.time_elapsed_string
	Meat_label.text = str(GameManager.meat_counter)
	
	#timer_label.text = str(time_lapsed)

func on_meat_collected(reg_value: int) -> void:
	Meat_label.counter += 1
	Meat_label.text = str(Meat_label)
	
