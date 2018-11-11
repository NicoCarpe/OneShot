extends KinematicBody2D

export var MOTION_SPEED = 100
var player
func _ready():
	player = get_tree().root.get_node("Level/Player")
var movedir = Vector2(1,0)
var anim = "idle"
var newAnim = "idle"

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	if canSeeTarget():
		newAnim = "walking"
		if newAnim != anim:
			$AnimationPlayer.play("walking")
			anim = newAnim
		movedir = Vector2(1, 0).rotated(get_angle_to(player.position))
		if movedir.x > 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
		var motion = movedir.normalized() * MOTION_SPEED
		var collision = move_and_collide(motion*delta)
		if collision:
			if collision.collider.is_in_group("Player"):
				collision.collider.playerHit()
			move_and_slide(motion)
	else:
		newAnim = "idle"
		if newAnim != anim:
			$AnimationPlayer.play("idle")
			anim = newAnim

func canSeeTarget():
	#Raycast to check if can see target
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, player.position, [self], 3) # Hits environment, player
	if result:
		if result.collider.is_in_group("Player"): # Sees player and nothing inbetween
			return true
	return false # Failed to detect target


func onHit():
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.disabled = true
	hide()

func _on_AudioStreamPlayer2D_finished():
	queue_free()
