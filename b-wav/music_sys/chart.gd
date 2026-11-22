class_name Chart

const CHART_ENDING_CHRS = 3

class Timing:
	var beats_per_measure: int
	var starting_time: int
	var bpm: int

class Hold:
	var start_ms: int
	var end_ms: int
	var lane: int

class Tap:
	var start_ms: int
	var lane: int

class ChartData:
	# Queries are basically just binary searches
	# from the start ms, or just a queue
	var timings: Array[Timing] = []
	var holds: Array[Hold] = []
	var taps: Array[Tap] = []

## Assumes that the data string provided is correct, so Yeah
static func parse_chart_data(data: String) -> ChartData:
	var lines = data.split('\n')
	var chart = ChartData.new()
	var start = 0
	
	# Skip to the data of the chart
	while lines[start] != '-': start += 1
	
	for i in range(start, len(lines), 1):
		var line = lines[i]
		if line.begins_with("timing"):
			# timing info
			var timing = Timing.new()
			var timing_data = line.substr(len("timing") + 1, line.length() - CHART_ENDING_CHRS).split(',')
			timing.beats_per_measure = int(timing_data[2])
			timing.starting_time = int(timing_data[0])
			timing.bpm = int(timing_data[1])
			
			chart.timings.append(timing)
		elif line.begins_with("hold"):
			# hold note
			var hold = Hold.new()
			var hold_data = line.substr(len("hold") + 1, line.length() - CHART_ENDING_CHRS).split(',')
			hold.start_ms = int(hold_data[0])
			hold.end_ms = int(hold_data[1])
			hold.lane = int(hold_data[2])
			
			chart.holds.append(hold)
		elif line.begins_with("("):
			# tap note
			var tap = Tap.new()
			var tap_data = line.substr(1, line.length() - CHART_ENDING_CHRS).split(',')
			tap.start_ms = int(tap_data[0])
			tap.lane = int(tap_data[1])
			chart.taps.append(tap)
	return chart
