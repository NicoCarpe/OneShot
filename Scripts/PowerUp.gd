extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (String, "Normal", "Bounce") var bulletType
var color = Color(1, 1, 1)
var y = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	$Sprite.position.y = sin(y/20)*2
	y += 1


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		if bulletType == "Normal":
			color = "res://Sprites/icons 1.png"
		if bulletType == "Bounce":
			color = "res://Sprites/icons 3.png"
		body.changeBullet(bulletType, color)
