extends RichTextLabel

@export var randomTexts: Array[String] = ["Make More Text Prompts!"]
var textToBeTyped: String = ""
var currentChar: int = 0

var typedText: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	textToBeTyped = randomTexts.pick_random()
	text = textToBeTyped

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "[center][color=black]%s[/color][color=#c7c7c7]%s[/color][/center]" % [typedText.substr(0, currentChar), textToBeTyped.substr(currentChar)]

func _unhandled_input(event):
	if currentChar >= textToBeTyped.length():
		return

	var nextChar = textToBeTyped.unicode_at(currentChar)
	if event is InputEventKey:
		if event.unicode == 0:
			return
		if event.pressed and event.unicode == nextChar:
			print("Correct")
			typeLetter()
		elif event.pressed and event.unicode != nextChar:
			print("pressed: " + str(event.unicode))
			print("expected: " + str(nextChar))
			failLetter()

func typeLetter():
	typedText += textToBeTyped[currentChar]
	currentChar += 1
	
func failLetter():
	print("fail letter")
	pass 
