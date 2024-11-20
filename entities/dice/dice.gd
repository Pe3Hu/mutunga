@tool
class_name Dice extends RigidBody3D


signal roll_finished(face)
enum ASPECT {OFFENSE, DEFENSE, SENSE, STEALTH, EXPERIENCE}


@export var dimension: float = 2:
	set(dimension_):
		dimension = dimension_
		%Cube.mesh.size = Vector3.ONE * dimension * 0.99
		%CollisionShape3D.shape.size = %Cube.mesh.size
		
		for face in %Faces.get_children():
			face.dimension = dimension
@export var aspect: ASPECT:
	set(aspect_):
		aspect = aspect_
		
		if not is_node_ready():
			await self.ready
		
		match aspect:
			ASPECT.OFFENSE:
				%Cube.mesh.material.albedo_color = Color.from_hsv(0.0 / 360.0, 0.9, 0.9)
			ASPECT.DEFENSE:
				%Cube.mesh.material.albedo_color = Color.from_hsv(210.0 / 360.0, 0.9, 0.9)
			ASPECT.SENSE:
				%Cube.mesh.material.albedo_color = Color.from_hsv(120.0 / 360.0, 0.9, 0.9)
			ASPECT.STEALTH:
				%Cube.mesh.material.albedo_color = Color.from_hsv(270.0 / 360.0, 0.9, 0.9)
			ASPECT.EXPERIENCE:
				%Cube.mesh.material.albedo_color = Color.from_hsv(60.0 / 360.0, 0.9, 0.9)


var start_position: Vector3
var roll_strength = 30
var is_rolling = false


func _ready() -> void:
	position = start_position
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and !is_rolling:
		_roll()
	
func _roll() -> void:
	#reset state
	sleeping = false
	freeze = false
	transform.origin = start_position
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	#random rotation
	transform.basis = Basis(Vector3.RIGHT, randf_range(0, 2 * PI)) * transform.basis
	transform.basis = Basis(Vector3.UP, randf_range(0, 2 * PI)) * transform.basis
	transform.basis = Basis(Vector3.FORWARD, randf_range(0, 2 * PI)) * transform.basis
	
	#random throw impulse
	var throw_vector = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	angular_velocity = throw_vector * roll_strength / 2
	apply_central_impulse(throw_vector * roll_strength)
	is_rolling = true


func _on_sleeping_state_changed() -> void:
	if sleeping:
		var landed_on_side = false
		
		for face in %Faces.get_children():
			if face.get_node("%RayCast3D").is_colliding():
				var opposite_index = (%Faces.get_child_count() / 2 + face.get_index()) % %Faces.get_child_count()
				var opposite_face = %Faces.get_child(opposite_index)
				is_rolling = false
				landed_on_side = true
				roll_finished.emit(opposite_face)
		
		if !landed_on_side:
			_roll()


func _on_roll_finished(face: Variant) -> void:
	print([face.value, get_index()])
