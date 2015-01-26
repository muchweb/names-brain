LineByLineReader = require 'line-by-line'
brain = require 'brain'
probabilities = {}

class LetterMap

	constructor: (options={}) ->
		@[key] = option for key, option of options
		@map.sort (a, b) -> b[1] - a[1]

	GetProbableLetter: ->
		return null if @map.length is 0

		unless @sum?
			@sum = @map.reduce (prev, cur) ->
				prev += cur[1]
			, 0

		rand = Math.floor (Math.random() * @sum) + 1
		index = 0
		while rand > 0
			letter = @map[index]
			rand -= letter[1]
			index++
		letter[0]

	GetProbableElement: (probabilities_array) ->
		letter = @GetProbableLetter()
		elements = probabilities_array.filter (item) ->
			letter is item.key
		return null if elements.length is 0
		elements.shift()

	@RandomElement = (array) ->
		array[Math.floor(Math.random()*array.length)]

	@Generate: (probabilities_array, maxlength) ->
		maxlength = Math.ceil(Math.random() * 10) + 4 unless maxlength?
		element = LetterMap.RandomElement probabilities_array
		name = ''
		dead_end = false
		while name.length < maxlength
			name += element.key
			element_new = element.GetProbableElement probabilities_array
			if element_new is null
				dead_end = true
				console.log 'cannot go past', element
				break
			element = element_new

		name: name
		dead_end: dead_end

	@MapFromFile: (path, callback) ->
		lr = new LineByLineReader path

		lr.on 'error', (err) ->
			return callback err

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
				probabilities_array.push new LetterMap
					key: key
					map: set_major
			callback null, probabilities_array

LetterMap.MapFromFile 'names-male.txt', (error, probabilities_array) ->
	console.log '-- male --'
	console.log (LetterMap.Generate probabilities_array).name
	console.log (LetterMap.Generate probabilities_array).name
	console.log (LetterMap.Generate probabilities_array).name
	console.log (LetterMap.Generate probabilities_array).name
	console.log (LetterMap.Generate probabilities_array).name

	LetterMap.MapFromFile 'names-female.txt', (error, probabilities_array) ->
		console.log '-- female --'
		console.log (LetterMap.Generate probabilities_array).name
		console.log (LetterMap.Generate probabilities_array).name
		console.log (LetterMap.Generate probabilities_array).name
		console.log (LetterMap.Generate probabilities_array).name
		console.log (LetterMap.Generate probabilities_array).name
