require_relative "commands"
require_relative "dvalues"
require "tty-table"
system "clear"
puts "Welcome to my bowling score program!"
puts "What is your name?"
$score_totaller[0] = gets.chomp
score_screen()
`say "bowling"`

while $frame <= 10
  if $quitter == 1
    system "clear"
    break
  end
  knockdown_pins()
  strike_check($score_totaller)
  totalling($frame)
  $frame += 1
  $current_bowl = 1
  score_screen()
end

game_over()
