class_name Prediction extends Resource


var aspects: Dictionary
var bans: Array[int]
var total_aspect_counter: int = 0


func change_aspect(aspect_: Constants.ASPECT, value_: int) -> void:
	if !aspects.has(aspect_):
		aspects[aspect_] = 0
	
	aspects[aspect_] += value_
	
	if aspects[aspect_] <= 0:
		aspects.erase(aspect_)
	
	total_aspect_counter += value_
	
func add_ban(ban_: int) -> void:
	if !bans.has(ban_):
		bans.append(ban_)
	
	bans.sort()
	
func calc_failure_probability() -> void:
	var failure_probability = 1.0
	var n = Global.dict.dice.title[Global.dict.dice.title.keys().front()].size()
	
	for aspect in aspects:
		var successes = 0
		
		for value in Global.dict.dice.title[aspect].values:
			if !bans.has(value):
				successes += 1
		
		failure_probability *= pow(float(n - successes) / n, aspects[aspect])
	
	print(failure_probability)
	
func calc_repetitions_probability() -> void:
	var n = Global.dict.dice.title[Global.dict.dice.title.keys().front()].size()
	
	for _i in range(2, total_aspect_counter + 1):
		var probability = 0.0
		
		for aspect in aspects:
			var result = {}
			var pascal = Global.get_pascal_triangle(aspects[aspect] - 1, _i - 1)
			
			for value in Global.dict.dice.title[aspect].probabilities:
				var repetitions_probability = Global.calc_probability(aspect, value, _i, aspects[aspect]) * pascal
				
				result[value] = repetitions_probability
			
			print([aspect, _i, result])
