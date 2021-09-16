require "tty-table"
$quitter = 0
$frame = 1
$spare = 0
$strike = 0
$current_bowl = 1
$pins = 0
$foul = 0
$remaining_pins = 10
$bonus_round = 0
$hidden_array = [0, 0, 0]
$user_input = ""
$pin_report = ""
##
##
$score_counter = ["", [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0, 0]]
$score_totaller = ["Score:", "", "", "", "", "", "", "", "", "", ""]
$framies = ["", "Frame 1", "Frame 2", "Frame 3", "Frame 4", "Frame 5", "Frame 6", "Frame 7", "Frame 8", "Frame 9", "Frame 10"]
##
$table = TTY::Table.new($framies, [$score_counter, $score_totaller])
