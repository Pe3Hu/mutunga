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
	var combinations = Global.get_all_combinations(aspects)
	var result = {}
	
	for _i in range(2, total_aspect_counter + 1):
		result[_i] = {}
		
		for value in Global.arr.value:
			result[_i][value] = 0
			
			for positive_combination in combinations[_i]:
				var probability = 1.0
				var full_combination = Global.get_full_combination(aspects, positive_combination)
				
				#var partial_permutations = 1
				var permutations = 1
				var keys = full_combination.keys()
				keys.sort()
				
				for aspect in keys:#full_combination:
					#var pascal = Global.get_pascal_triangle(aspects[aspect] - 1, _i - 1)
					#
					#if full_combination[aspect] == 0:
						#pascal = 1
					var pascal = Global.get_pascal_triangle(aspects[aspect] - 1, full_combination[aspect] - 1)
						
					#var pascal = 1
					#
					#if full_combination[aspect] != 0:
						#pascal *= Global.get_pascal_triangle(aspects[aspect] - 1, full_combination[aspect] - 1)
						#pascal *= Global.get_pascal_triangle(aspects[aspect] - 1, _i - 1)
					
					if aspects[aspect] > 1 and (full_combination[aspect] != aspects[aspect] and full_combination[aspect] != 0):
						permutations *= Global.get_pascal_triangle(aspects[aspect], full_combination[aspect])
						print([full_combination, aspect, Global.get_pascal_triangle(aspects[aspect], full_combination[aspect])])
						#partial_permutations *= Global.get_partial_permutation(aspects[aspect], full_combination[aspect])
						#print([full_combination, aspect, Global.get_partial_permutation(aspects[aspect], full_combination[aspect])])
					
					var repetitions_probability = Global.calc_probability(aspect, value, full_combination[aspect], aspects[aspect]) * pascal
					print([aspect, repetitions_probability * 100])
					probability *= repetitions_probability
				
				result[_i][value] += probability * permutations#partial_permutations
				print([_i, value, full_combination, permutations, probability * 100, probability * permutations * 100])
			
			#total_probability += result[_i][value]
			if result[_i][value] != 0:
				print(["@",_i, value, result[_i][value] * 100])
	
	pass
	
	#var options = []
	#for aspect in aspects:
		#for _i in aspects[aspect]:
			#options.append(aspect)
	
	#var c = Global.get_all_combinations_based_on_size(aspects, 3)
	
	#print(total_probability)
		
		#for aspect in aspects:
			#if aspects[aspect] >= _i:
				#var result = {}
				#var pascal = Global.get_pascal_triangle(aspects[aspect] - 1, _i - 1)
				#
				#for value in Global.dict.dice.title[aspect].probabilities:
					#var repetitions_probability = Global.calc_probability(aspect, value, _i, aspects[aspect]) * pascal
					#
					#result[value] = repetitions_probability
				#
				#print([aspect, _i, result])
	
func get_rnd() -> void:
	if true:
		var a = {}
		a[1] = 1
		a[2] = 2
		a[3] = 3
		a[4] = 4
		var result = {}
		
		for _i in 10:
			#var value = Global.get_random_key(a)
			#var value = int(randfn(0.0, sqrt(2.0)))
			#var value = int(Global.rnd_levy(1, 2))
			#var value = int(randf_range(1, 5+1))
			
			
			#if value < -10:
				#value = -10
			#
			#if value > 10:
				#value = 10
			
			var value = Global.rnd_levy_int(1, 15)
			
			if !result.has(value):
				result[value] = 0
			
			result[value] += 1
		
		var keys = result.keys()
		keys.sort()
		
		for key in keys:
			print([key, result[key]])
		return
	
func sim_rolls() -> void:
	var repeats = 500000
	var result = {}
	
	for _i in repeats:
		var sum_roll = {}
		
		for aspect in aspects:
			var aspect_roll = Global.roll_dices(aspect, aspects[aspect])
		
			for value in aspect_roll:
				if !sum_roll.has(value):
					sum_roll[value] = 0
				
				sum_roll[value] += aspect_roll[value]
		
		for value in sum_roll:
			var count = sum_roll[value]
			
			if  count > 1:
				if !result.has(count):
					result[count] = {}
				
				if !result[count].has(value):
					result[count][value] = 0
					
				result[count][value] += 1
	
	var counts = result.keys()
	counts.sort()
	
	for count in counts:
		var values = result[count].keys()
		values.sort()
		
		for value in values:
			print([count, value, float(result[count][value]) / repeats * 100])
