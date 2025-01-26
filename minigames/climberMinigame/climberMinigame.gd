extends Node2D

signal changeSceneWin
signal changeSceneLose

func win(body):
	if body.is_in_group("player"):
		print(":)")
		await get_tree().create_timer(0.5).timeout
		changeSceneWin.emit()


func lose(body):
	if body.is_in_group("player"):
		print(":(")
		await get_tree().create_timer(0.5).timeout
		changeSceneLose.emit()
