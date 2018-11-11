extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (String, "Normal", "Bounce") var bulletType
var color = Color(1, 1, 1)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		if bulletType == "Bounce":
			color = Color(1, 0, 0)
		body.changeBullet(bulletType, color)
