fs = require 'fs'

fs.readFile 'names-male.txt', 'utf8', (err, data) ->
	return console.log err if err?
	console.log data
