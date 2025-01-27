extends Node2D

@onready var anim = $AnimationPlayer
@onready var va = $VA
@onready var vaAudio = $AudioStreamPlayer2D

var next = 0
var intro: Array[String] = ["I’ve always had the ability to read people's thought bubbles", \
 "From the day I was born", \
 "I dreamt I would grow up and become a superhero", \
 "That I would use my gift to help others", \
 "Unfortunately, I have bills to pay and the money isn’t going to make itself", \
 "So I’ll use my powers to tell people what they want to hear", \
 "because, let’s be honest, who wants to hear the truth."]

@export var va_audio: Array[AudioStream] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("intro")
func _process(delta):
	if Input.is_action_just_pressed("Skip"):
		get_tree().change_scene_to_file("res://Main Scenes/office.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func startGame():
	get_tree().change_scene_to_file("res://Main Scenes/office.tscn")

func progressText():
	vaAudio.stream = va_audio[next]
	vaAudio.play()
	va.text = intro[next]
	next += 1
