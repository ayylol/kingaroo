extends KinematicBody2D


export var speed : float = 180.0
export var knockBackForce : float = 100.0
export var controllerDeadzoneY : float = 0.25
export var controllerDeadzoneX : float = 0.25


var velocity : Vector2 = Vector2()
var time : float = 0
var hookTime : float = 0.5
var timeInHook : float = 0.0
var parent
var animationTree
var stateMachine


func _ready():
	parent = get_parent()
	animationTree = get_node("PlayerItems/AnimationTree")
	stateMachine = animationTree["parameters/playback"]


func _physics_process(delta):
	velocity = Vector2.ZERO
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity, Vector2.ZERO, true)
	fighting_input(delta)


func _input(event):
	if event is InputEventJoypadMotion:
		var direction : Vector2 = Input.get_vector("look_left", "look_right", "look_up", "look_down")
		if abs(direction.x) > controllerDeadzoneX || abs(direction.y) > controllerDeadzoneY:
			rotation_degrees = rad2deg(direction.angle())
	elif event is InputEventMouseMotion:
			look_at(get_global_mouse_position())


func fighting_input(delta):
	if velocity == Vector2.ZERO:
		stateMachine.travel("Idle")
	else:
		stateMachine.travel("Walk")
	if Input.is_action_pressed("left_punch"):
		time += delta
		if timeInHook < time:
			stateMachine.travel("LeftHookHold")
		elif time > hookTime:
			stateMachine.travel("LeftHookPre")
			timeInHook = time
	if Input.is_action_pressed("right_punch"):
		time += delta
		if timeInHook < time:
			stateMachine.travel("RightHookHold")
		elif time > hookTime:
			stateMachine.travel("RightHookPre")
			timeInHook = time
	if Input.is_action_just_released("left_punch"):
		if time < hookTime:
			stateMachine.travel("LeftJab")
		else:
			stateMachine.travel("Idle")
		time = 0
	if Input.is_action_just_released("right_punch"):
		if time < hookTime:
			stateMachine.travel("RightJab")
		else:
			stateMachine.travel("Idle")
		time = 0


#func _on_PunchArea2d_body_entered(body):
#	if body.is_in_group("Enemies"):
#		print("punching")
#		body.hit(position)

