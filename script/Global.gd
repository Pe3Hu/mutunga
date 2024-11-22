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
	arr.values = [1, 2, 3, 4, 5, 6, 7]
	
func init_dict() -> void:
	init_direction()
	
	init_dice()
	
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
	
func init_dice() -> void:
	dict.dice = {}
	dict.dice.title = {}
	
	var path = "res://entities/dice/dice.json"
	var array = load_data(path)
	
	for dice in array:
		var data = {}
		var words = dice.values.split(",")
		data.values = []
		data.probabilities = {}
		
		for word in words:
			var value = int(word)
			data.values.append(value)
			
			if !data.probabilities.has(value):
				data.probabilities[value] = 0
			
			data.probabilities[value] += 1.0 / words.size()
		
		var title = Constants.ASPECT.get(dice.title.to_upper())
		dict.dice.title[title] = data
	
func init_color():
	pass
	#var h = 360.0
	
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
	
func calc_probability(aspect_: Constants.ASPECT, value_: int, n_: int, k_: int) -> float:
	var probability = dict.dice.title[aspect_].probabilities[value_]
	return pow(probability, n_) * pow(1 - probability, k_ - n_)
	
func get_pascal_triangle(n_: int, k_: int) -> int:
	var result = 1
	
	for _i in range(k_ + 1, n_ + 1, 1):
		result *= _i
	
	for _i in range(2, n_ - k_ + 1, 1):
		result /= _i
	
	return result
