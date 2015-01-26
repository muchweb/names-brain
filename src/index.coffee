LineByLineReader = require 'line-by-line'
brain = require 'brain'
lr = new LineByLineReader 'names-male.txt'
probabilities = {}

class LetterMap
	constructor: (options={}) ->
		@[key] = option for key, option of options


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
		probabilities_array.push new LetterMap
			key: key
			map: set_major

	element = probabilities_array.RandomElement()
	name = ''
	dead_end = false
	while name.length < Math.ceil(Math.random() * 10) + 4
		name += element.key
		element = element.map.RandomElement()
		elements = probabilities_array.filter (item) ->
			element[0] is item.key

		if elements.length is 0
			dead_end = true
			break
		element = elements[0]
		
	console.log name
	console.log 'Dead end reached' if dead_end
