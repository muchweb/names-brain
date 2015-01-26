LineByLineReader = require 'line-by-line'
brain = require 'brain'
lr = new LineByLineReader 'names-male.txt'
probabilities = {}

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
