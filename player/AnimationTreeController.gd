extends AnimationTree


var soundFX = {}


var parent
var animationTree
var animationPlayer
var stateMachine


#func _ready():
#	parent = get_parent()
#	animationTree = parent.get_node("AnimationTree")
#	animationPlayer = parent.get_node("AnimationPlayer")
#	stateMachine = animationTree.get_node("parameters/playback")

#
#func _physics_process(delta):
#	if Input.is_action_pressed("left_punch"):
#		stateMachine.travel("")
