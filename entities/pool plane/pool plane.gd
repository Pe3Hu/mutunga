@tool
class_name PoolPlane extends StaticBody3D


enum ORIENTATION {X0, Y0, Z0, X1, Y1, Z1}
const thickness = 0.01

@export var dicepool: DicePool:
	set(dicepool_):
		dicepool = dicepool_
		dimensions = dicepool.dimensions
@export var dimensions: Vector3 = Vector3(20, 14, 20):
	set(dimensions_):
		dimensions = dimensions_
		orientation = orientation
@export var orientation: ORIENTATION:
	set(orientation_):
		orientation = orientation_
		
		if not is_node_ready():
			await self.ready
		
		%CollisionShape3D.shape.size = dimensions
		position = Vector3.ZERO
		
		match orientation:
			ORIENTATION.X0:
				%CollisionShape3D.shape.size.x *= thickness
				position.x = dimensions.x * 0.5
			ORIENTATION.Y0:
				%CollisionShape3D.shape.size.y *= thickness
				position.y = dimensions.y * 0.5
			ORIENTATION.Z0:
				%CollisionShape3D.shape.size.z *= thickness
				position.z = dimensions.z * 0.5
			ORIENTATION.X1:
				%CollisionShape3D.shape.size.x *= thickness
				position.x = -dimensions.x * 0.5
			ORIENTATION.Y1:
				%CollisionShape3D.shape.size.y *= thickness
				position.y = -dimensions.y * 0.5
			ORIENTATION.Z1:
				%CollisionShape3D.shape.size.z *= thickness
				position.z = -dimensions.z * 0.5
