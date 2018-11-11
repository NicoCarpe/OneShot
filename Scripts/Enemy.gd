extends KinematicBody2D

export var MOTION_SPEED = 100
var player
func _ready():
	player = get_tree().root.get_node("Level/Player")

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
	rotation += get_angle_to(player.position)
	var movedir = Vector2(1,0).rotated(rotation)
	var motion = movedir.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion*delta)
	if collision:
		if collision.collider.is_in_group("Player"):
			collision.collider.playerHit()
		move_and_slide(motion)

func onHit():
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.disabled = true
	hide()

func _on_AudioStreamPlayer2D_finished():
	queue_free()
