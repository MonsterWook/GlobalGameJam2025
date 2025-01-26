extends Node2D

@onready var bg = $bg

# Called when the node enters the scene tree for the first time.
func _ready():
	bg.play("arrow")
	await get_tree().create_timer(5).timeout
	bg.play("normal")

func win(body):
	if body.is_in_group("player"):
		print("win")
