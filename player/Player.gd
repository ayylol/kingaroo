extends KinematicBody2D


export var speed : float = 180.0
export var knockBackForce : float = 100.0


var velocity : Vector2 = Vector2()
var doubleJump = false
var time : float = 0
var hookTime : float = 0.5
var timeInHook : float = 0.25
var isPunching : bool = false


func _ready():
	$Sprite.play("idle")


func _physics_process(delta):
	velocity = Vector2.ZERO
	isPunching = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity, Vector2.ZERO, true)
	
	if Input.is_action_pressed("left_punch"):
		time += delta
		isPunching = true
		if timeInHook < time:
			$Sprite.play("hold left hook")
		elif time > hookTime:
			$Sprite.play("pre left hook")
			timeInHook = time
	if Input.is_action_pressed("right_punch"):
		time += delta
		isPunching = true
		if timeInHook < time:
			$Sprite.play("hold right hook")
		elif time > hookTime:
			$Sprite.play("pre right hook")
			timeInHook = time
	if Input.is_action_just_released("left_punch"):
		if time < hookTime:
			$Sprite.play("left punch")
		else:
			$Sprite.play("post left hook")
		time = 0
	if Input.is_action_just_released("right_punch"):
		if time < hookTime:
			$Sprite.play("right punch")
		else:
			$Sprite.play("post right hook")
		time = 0
	
	$Sprite.look_at(get_global_mouse_position())
	$Sprite.rotation_degrees += 90


func _on_Sprite_animation_finished():
	if $Sprite.animation == "left punch" || $Sprite.animation == "right punch" || $Sprite.animation == "post left hook" || $Sprite.animation == "post right hook":
		$Sprite.play("idle")
		time = 0
		if velocity != Vector2.ZERO && isPunching == false:
			$Sprite.play("walk")


#func _on_PunchArea2d_body_entered(body):
#	if body.is_in_group("Enemies"):
#		print("punching")
#		body.hit(position)
