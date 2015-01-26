LineByLineReader = require 'line-by-line'
brain = require 'brain'
lr = new LineByLineReader 'names-male.txt'
map = []

lr.on 'error', (err) ->
	# 'err' contains error object

lr.on 'line', (line) ->
	list = line.split ''
	for index in [0..(list.length-2)]
		map.push
			input: list[index]
			output: list[index+1]

	# 'line' contains the current line without the trailing newline character.

lr.on 'end', ->
	net = new brain.NeuralNetwork
	console.log map
	net.train map
	console.log net.run 'J'

	# All lines are read, file is closed now.
