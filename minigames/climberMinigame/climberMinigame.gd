extends Node2D

signal changeSceneWin
signal changeSceneLose

func win(body):
	print(":)")
	await get_tree().create_timer(1).timeout
	changeSceneWin.emit()


func lose(body):
	print(":(")
	await get_tree().create_timer(1).timeout
	changeSceneLose.emit()
