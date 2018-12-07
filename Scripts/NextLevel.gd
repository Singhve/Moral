extends Area2D

export(String, FILE, "*.tscn") var Select_Level


func _ready():
	pass


func _on_NextLevel_body_entered(body):
	if "Player" in body.name:
		var Sound = get_node("Sound")
		Sound.play()
		$Timer.start()

func _on_Timer_timeout():
	get_tree().change_scene(Select_Level)