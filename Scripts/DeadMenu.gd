extends Control

func _ready():
	$Play_Again.grab_focus()
	
func _on_Play_Again_pressed():
	print("pressed")
	get_tree().change_scene("Levels/Level_1.tscn")
	
func _on_Exit_pressed():
	get_tree().quit()