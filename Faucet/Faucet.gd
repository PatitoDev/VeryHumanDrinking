extends Node2D
var objects: Array[Array] = []

@export var despawnPoint: Node2D;
@onready var handleMarker = $HandleOrigin/HandleMarker
@onready var grabHandleArea = $HandleOrigin/GrabHandleArea
@onready var waterFlowTimer = $WaterFlowTimer
@onready var handleOrigin = $HandleOrigin
@onready var cir_shape := CircleShape2D.new()
@export var tex: Texture2D
@export var spawnRad: float
var texSize: float = 48 / 2
var pointer: bool = true
@onready var attrForce: float = 20
@export var vpContainer: Node;

var rotationIgnoreThreshold = 180;
var waterFlow = 0;
var maxWaterFlow = 270;


func _ready() -> void:
	cir_shape.radius = 8 / 2
	cir_shape.custom_solver_bias = 0.1
	setWaterFlow(0)

func setWaterFlow(value: int):
	var newValue = clamp(value, 0, maxWaterFlow);
	if (abs(newValue - waterFlow) > rotationIgnoreThreshold):
		if (waterFlow > 180):
			newValue = maxWaterFlow;
		else:
			newValue = 0;
	waterFlow = newValue;
	handleOrigin.rotation_degrees = waterFlow;
	if waterFlow > 10:
		if waterFlowTimer.is_stopped():
			waterFlowTimer.start();
	else:
		waterFlowTimer.stop();
	waterFlowTimer.wait_time = (pow((maxWaterFlow - waterFlow) / 1000.0, 2));

func create_object(pos: Vector2):
	var ps := PhysicsServer2D
	var object = ps.body_create()
	ps.body_set_space(object, get_world_2d().space)
	ps.body_add_shape(object, cir_shape)
	ps.body_set_param(object, ps.BODY_PARAM_FRICTION, 0.1)
	ps.body_set_param(object, ps.BODY_PARAM_MASS, 0.1 * 10)
	ps.body_set_mode(object, ps.BODY_MODE_RIGID_LINEAR)
	ps.body_set_param(object, ps.BODY_PARAM_LINEAR_DAMP, 1)
	var trans := Transform2D(0, pos)
	ps.body_set_state(object, ps.BODY_STATE_TRANSFORM, trans)
	
	var vp = vpContainer.get_canvas_item();
	
	var rs := RenderingServer
	var img := rs.canvas_item_create()
	rs.canvas_item_set_parent(img, vp) #get_canvas_item())
	rs.canvas_item_add_texture_rect(img, Rect2(texSize/-2, texSize/-2, texSize, texSize), tex)
	rs.canvas_item_set_transform(img, trans)

	objects.append([object, img])

var initialPositionDifference = null;
var isGrabbed = false;

func setIsGrabbed(value: bool):
	isGrabbed = value;
	var handledDiff = handleOrigin.global_position - handleMarker.global_position;
	initialPositionDifference = get_global_mouse_position() + handledDiff;

func _physics_process(delta):
	if (isGrabbed):
		var mousePos = get_global_mouse_position();
		var angle = rad_to_deg(mousePos.angle_to_point(initialPositionDifference)) + 180;
		setWaterFlow(angle);
	
	var index: int = 0
	for pair in objects:
		var object: RID = pair[0]
		var img: RID = pair[1]
		var trans: Transform2D = PhysicsServer2D.body_get_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM)
		#trans.origin -= $Marker2D.global_position
		if trans.origin.y > despawnPoint.global_position.y: # remove if below this point
			objects.remove_at(index)
			PhysicsServer2D.free_rid(object)
			RenderingServer.free_rid(img)
		else:
			RenderingServer.canvas_item_set_transform(img, trans)
		index += 1

func _exit_tree():
	for pair in objects:
		var object: RID = pair[0]
		var img: RID = pair[1]
		PhysicsServer2D.free_rid(object)
		RenderingServer.free_rid(img)

func _on_timer_timeout():
	create_object($Marker2D.global_position);
