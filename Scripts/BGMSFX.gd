extends Node2D

var db = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func play(audio):
	$BGMSFX.stream = load(audio)
	$BGMSFX.volume_db = db
	$BGMSFX.play()