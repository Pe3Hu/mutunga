extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var color = {}
var dict = {}


func _ready() -> void:
	if dict.keys().is_empty():
		init_arr()
		init_color()
		init_dict()
	
	#get_tree().bourse.resource.after_init()
	
func init_arr() -> void:
	pass
	
func init_dict() -> void:
	init_direction()
	
func init_direction() -> void:
	dict.direction = {}
	dict.direction.linear2 = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	dict.direction.diagonal = [
		Vector2i( 1,-1),
		Vector2i( 1, 1),
		Vector2i(-1, 1),
		Vector2i(-1,-1)
	]
	
	dict.direction.hybrid = []
	
	for _i in dict.direction.linear2.size():
		var direction = dict.direction.linear2[_i]
		dict.direction.hybrid.append(direction)
		direction = dict.direction.diagonal[_i]
		dict.direction.hybrid.append(direction)
	
func init_color():
	pass
	#var h = 360.0
	
	#color.aspect[TokenResource.Aspect.NETWORK] = Color.from_hsv(160 / h, 0.8, 0.5)
	#color.aspect[TokenResource.Aspect.ENERGY] = Color.from_hsv(60 / h, 0.9, 0.9)
	#color.aspect[TokenResource.Aspect.SPEED] = Color.from_hsv(35 / h, 0.9, 0.9)
	#color.aspect[TokenResource.Aspect.PAYLOAD] = Color.from_hsv(0 / h, 0.0, 0.7)
	#color.aspect[TokenResource.Aspect.HACK] = Color.from_hsv(280 / h, 0.9, 0.9)
	#color.aspect[TokenResource.Aspect.FIREPOWER] = Color.from_hsv(0 / h, 0.9, 0.9)
	#color.aspect[TokenResource.Aspect.BARRIER] = Color.from_hsv(210 / h, 0.9, 0.9)
	#color.aspect[TokenResource.Aspect.STEALTH] = Color.from_hsv(115 / h, 0.9, 0.7)
	
func save(path_: String, data_): #: String
	var file = FileAccess.open(path_, FileAccess.WRITE)
	file.store_string(data_)
	
func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()
	
func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
	
func get_all_combinations_based_on_size(array_: Array, size_: int) -> Array:
	var combinations = {}
	combinations[0] = array_.duplicate()
	combinations[1] = []
	
	for child in array_:
		combinations[1].append([child])
	
	for _i in size_ - 1:
		set_combinations_based_on_size(combinations, _i + 2)
	
	return combinations[size_]
	
func set_combinations_based_on_size(combinations_: Dictionary, size_: int) -> void:
	var parents = combinations_[size_ - 1]
	combinations_[size_] = []
	
	for parent in parents:
		for child in combinations_[0]:
			if !parent.has(child):
				var combination = []
				combination.append_array(parent)
				combination.append(child)
				combination.sort_custom(func(a, b): return combinations_[0].find(a) < combinations_[0].find(b))
				
				if !combinations_[size_].has(combination):
					combinations_[size_].append(combination)
	
