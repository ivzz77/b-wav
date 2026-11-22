extends Node2D

func _ready() -> void:
	var chart = "AudioOffset:0
-
timing(0,28.00,100.00);
timing(4508,28.00,2.00);
timing(12008,28.00,100.00);
timing(14106,56.00,100.00);
timing(16606,224.00,100.00);
timing(17140,112.00,4.00);
(21426,1);
(21426,4);
(21694,1);
(21694,4);
(22095,2);
(22095,3);
(22363,2);"

	var chart_data = Chart.parse_chart_data(chart)
	for timing in chart_data.timings:
		print("timing(%d,%d,%d)" % [timing.starting_time, timing.bpm, timing.beats_per_measure])
		
	for hold in chart_data.holds:
		print("hold(%d,%d,%d)" % [hold.start_ms, hold.end_ms, hold.lane])

	for tap in chart_data.taps:
		print("tap(%d,%d)" % [tap.start_ms, tap.lane])
