extends Control

func _ready():
	$Start_Game.grab_focus()
	
func _on_Start_Game_pressed():
	print("pressed")
	get_tree().change_scene("Levels/Level_1.tscn")
func _on_Exit_pressed():
	get_tree().quit()