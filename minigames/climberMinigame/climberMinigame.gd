extends Node2D

signal changeSceneWin
signal changeSceneLose

func win(body):
	if body.is_in_group("player"):
		print(":)")
		await get_tree().create_timer(1).timeout
		changeSceneWin.emit()


func lose(body):
	if body.is_in_group("player"):
		print(":(")
		await get_tree().create_timer(1).timeout
		changeSceneLose.emit()
