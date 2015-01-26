LineByLineReader = require 'line-by-line'
brain = require 'brain'
lr = new LineByLineReader 'names-male.txt'
probabilities = {}

Array.prototype.RandomElement = () ->
	@[Math.floor(Math.random()*@.length)]

lr.on 'error', (err) ->
	# 'err' contains error object

lr.on 'line', (line) ->
	list = line.split ''
	for index in [0..(list.length-2)]
		a = "#{list[index]}"
		b = "#{list[index+1]}"
		probabilities[a] = {} unless probabilities[a]?
		probabilities[a][b] = 0 unless probabilities[a][b]?
		probabilities[a][b]++

lr.on 'end', ->
	probabilities_array = []
	for key, major of probabilities
		set_major = []
		for letter, count of major
			set_major.push [letter, count]
		set_major.sort (a, b) -> b[1] - a[1]
		probabilities_array.push [key, set_major]

	start_element = probabilities_array.RandomElement()
	letter = start_element[0]

	name = ''
	dead_end = false
	while name.length < Math.ceil(Math.random() * 10) + 4
		name += letter
		found = probabilities_array.filter (item) -> item[0] is letter
		if found.length is 0
			dead_end = true
			break
		found = found[0]
		letter = found[1][0][0]
	console.log name
	console.log 'Dead end reached' if dead_end
