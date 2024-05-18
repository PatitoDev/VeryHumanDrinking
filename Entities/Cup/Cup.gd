extends RigidBody2D

var _target: Node2D = null;

func _ready() -> void:
	lock_rotation = false;

func setTarget(target: Node2D):
	lock_rotation = target != null;
	_target = target;

func _physics_process(delta):
	if _target:
		var I = 5000*mass#infuence
		var S = 20#stiffness 
		var P = _target.global_position - global_transform.origin
		var M = mass
		var V = linear_velocity
		var impulse = (I*P) - (S*M*V)
		apply_central_impulse(impulse * delta)
		rotation_degrees = _target.rotation_degrees;
