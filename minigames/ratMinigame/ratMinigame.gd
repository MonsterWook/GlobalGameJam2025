extends Node2D

signal changeSceneWin
signal changeSceneLose

@onready var bg = $bg

# Called when the node enters the scene tree for the first time.
func _ready():
	bg.play("arrow")
	await get_tree().create_timer(5).timeout
	bg.play("normal")

func win(body):
	if body.is_in_group("player"):
		print("win")
		await get_tree().create_timer(0.5).timeout
		changeSceneWin.emit()
