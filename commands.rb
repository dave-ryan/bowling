require "./dvalues"

def wrong
  score_screen()
  puts ""
  puts "No. Please enter how many pins you knocked down."
  `say "error"`
end

def correct_input(pins)
  pins.to_i.to_s == pins && pins.to_i <= 10 && pins.to_i >= 0 && $remaining_pins - pins.to_i >= 0
end

def strike_check(totaller)
  cloak()
  index = 1
  while index < totaller.length
    #3 strikes in a row
    if ($score_counter[index] == "X" && $score_counter[index + 1] == "X" && $score_counter[index + 2] == "X") || ($score_counter[index] == "X" && $score_counter[index + 1] == "X" && $score_counter[index + 2][0] == 10) || ($score_counter[index] == "X" && $score_counter[index + 1][0] == 10 && $score_counter[index + 1][1] == 10)
      totaller[index] = 30
      totalling(index)

      #2 strikes, then a regular throw
    elsif $score_counter[index] == "X" && $score_counter[index + 1] == "X" && $strike == 0
      totaller[index] = 20 + $score_counter[index + 2][0]
      totaller[index + 1] = 10 + $score_counter[index + 2][0]
      totalling(index)

      #1 strike, then regular throws
    elsif $score_counter[index] == "X" && $strike == 0
      if $score_counter[index + 1][1] == "/"
        totaller[index] = 20
        totalling(index)
      else
        totaller[index] = 10 + $score_counter[index + 1][0] + $score_counter[index + 1][1]
        totalling(index)
      end
    end
    index += 1
  end
  decloak()
end

def spare_check
  if $spare == 1
    $score_totaller[$frame - 1] = 10 + $pins
    totalling($frame - 1)
    $spare = 0
  end
end

def totalling(frame)
  if frame != 10
    if $score_counter[$frame].is_a?(Array)
      unless $score_counter[$frame][1] == "/"
        $score_totaller[$frame] = $score_counter[$frame].sum
      end
    end
    if $score_totaller[frame - 1].is_a?(Integer) && $score_totaller[frame].is_a?(Integer)
      $score_totaller[frame] += $score_totaller[frame - 1]
    end
  end
  if frame == 10 && $score_counter[10][0].is_a?(Integer) && $score_counter[10][1].is_a?(Integer)
    $score_totaller[frame] = $score_counter[10].sum
  end
end

def score_screen
  system "clear"
  puts "Welcome to my bowling score program!"
  puts ""
  puts "Input how many pins you knocked down. Q to quit and F for a foul"
  puts ""
  $table = TTY::Table.new($framies, [$score_counter, $score_totaller])
  puts $table.render(:unicode)
  puts ""
  puts ""
  puts "                     #{$pin_report}"
  puts ""
  puts ""
  puts "Current frame is #{$frame}"
  puts "Current bowl is #{$current_bowl}"
  puts "There are #{$remaining_pins} pins left"
  puts "How many pins did you knock down?"
end

def special_names
  if ($pins == 10 && $current_bowl == 1 && $frame < 10) || ($user_input.downcase == "x") || ($user_input.downcase == "strike")
    $score_counter[$frame] = "X"
    $score_totaller[$frame] = ""
    $strike = 1
    $current_bowl += 1
    $pin_report = "!! S T R I K E !!"
    `say "strike"`
  elsif $pins == 10 && $frame == 10
    $score_counter[$frame][$current_bowl - 1] = "X"
    $remaining_pins = 10
    $bonus_round = 1
    $strike = 1
    $pin_report = "!! S T R I K E !!"
    `say "strike"`
  elsif $remaining_pins == 0 && $current_bowl == 2
    $score_counter[$frame][1] = "/"
    $score_totaller[$frame] = ""
    $pin_report = "!! SPARE !!"
    `say "spare"`
    $spare = 1
    $strike = 0
    if $frame == 10
      $remaining_pins = 10
      $bonus_round = 1
      $strike = 0
    end
  elsif $pins == 0
    $strike = 0
    $pin_report = "!! GUTTER BALL !!"
    `say "gutter ball"`
  else
    $strike = 0
    $pin_report = "You knocked down #{$pins} pins!"
  end
end

def score_loop(pins)
  $pins = pins
  $remaining_pins -= $pins
  $score_counter[$frame][$current_bowl - 1] = $pins
  spare_check()
  special_names()
  $current_bowl += 1
  score_screen()
end

def knockdown_pins
  $current_bowl = 1
  $remaining_pins = 10
  while $current_bowl < 3 + $bonus_round
    $user_input = gets.chomp
    if $user_input.downcase == "f"
      `say "foul"`
      if $current_bowl == 1 && $foul == 0
        score_screen()
        puts "FOUL!, but it's your first bowl this frame, so try again"
        $foul = 1
      else
        score_screen()
        puts "FOUL! Move on to your next bowl"
        $foul = 0
        $current_bowl += 1
        break
      end
    elsif $user_input.downcase == "x"
      score_loop(10)
    elsif $user_input == "/" && $remaining_pins != 10
      score_loop($remaining_pins)
    elsif $user_input.downcase == "q"
      $quitter = 1
      break
    elsif correct_input($user_input)
      score_loop($user_input.to_i)
    else
      wrong()
    end
  end
end

def game_over
  unless $quitter == 1
    p $score_totaller[10]
    p $score_totaller[9]
    $score_totaller[10] += $score_totaller[9]
    system "clear"
    puts "Welcome to my bowling score program!"
    puts ""
    $table = TTY::Table.new($framies, [$score_counter, $score_totaller])
    puts $table.render(:unicode)
    puts "Your final score is #{$score_totaller[10]}!!!"
    `say "game over"`
    if $score_totaller[10] < 100
      puts "You stink!"
      `say "ha ha ha"`
    elsif $score_totaller[10] < 200
      puts "Not bad!"
    elsif $score_totaller[10] < 250
      puts "Pretty damn good!"
    elsif $score_totaller[10] < 300
      puts "Incredible! Professional level!"
    elsif $score_totaller[10] == 300
      puts "Perfect game!!! You cheated btw."
    end
  end
end

def cloak
  index = 0
  while index < 3
    $hidden_array[index] = $score_counter[10][index]
    if $score_counter[10][index] == "X"
      $score_counter[10][index] = 10
    elsif $score_counter[10][index] == "/"
      $score_counter[10][index] = 10 - $score_counter[10][index - 1]
    else
    end
    index += 1
  end
end

def decloak
  $score_counter[10] = $hidden_array
  $hidden_array = [0, 0, 0]
end
