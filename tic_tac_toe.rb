require 'colorize'

# Add an array of colors
COLORS = [:red, :green, :blue, :yellow, :cyan, :light_white]

# Separate colors for X and O
PLAYER_COLORS = {'X' => :light_red, 'O' => :light_blue}

class TicTacToe
  CELL_MAPPING = {
    7 => [0, 0],
    8 => [0, 1],
    9 => [0, 2],
    4 => [1, 0],
    5 => [1, 1],
    6 => [1, 2],
    1 => [2, 0],
    2 => [2, 1],
    3 => [2, 2]
  }

  def initialize
    @current_player = 'X'
    @scoreboard = {'X' => 0, 'O' => 0}
    @color_index = 0
    play_game
  end

  def play_game
    until @scoreboard['X'] == 5 || @scoreboard['O'] == 5
      @board = Array.new(3) { Array.new(3, ' ') }
      @game_over = false

      until @game_over
        print_board
        make_move
        if check_game_over
          print_board
          if check_winner
            puts "One point to #{@current_player}!".colorize(COLORS[@color_index])
            @scoreboard[@current_player] += 1
            @color_index = (@color_index + 1) % COLORS.length
          else
            puts "It's a tie!".colorize(COLORS[@color_index])
          end
          @game_over = true
        else
          switch_player
        end
      end
      print_scoreboard
    end

    if @scoreboard['X'] == 5
      puts "Congratulations, player 'X'! You've won the game!".colorize(PLAYER_COLORS['X'])
      display_winner_art('X')
    else
      puts "Congratulations, player 'O'! You've won the game!".colorize(PLAYER_COLORS['O'])
      display_winner_art('O')
    end

    new_game_prompt
  end

  def new_game_prompt
    puts "Do you want to play a new game? (Y/N)"
    response = gets.chomp.upcase
    if response == 'Y'
      initialize
    else
      puts "Thanks for playing. Goodbye!"
    end
  end

  def rainbow_text(text)
    rainbow_colors = [:red, :light_red, :yellow, :green, :light_green, :blue, :light_blue, :magenta, :light_magenta]
    text.chars.each_with_index do |char, index|
      print char.colorize(rainbow_colors[index % rainbow_colors.size])
    end
    puts
  end

  def print_scoreboard
    rainbow_text("Scoreboard:")
    puts ("X: #{@scoreboard['X']}").colorize(PLAYER_COLORS['X'])
    puts ("O: #{@scoreboard['O']}").colorize(PLAYER_COLORS['O'])
  end



  def colorized_cell(row, col)
    piece = @board[row][col]
    if PLAYER_COLORS.key?(piece)
      piece.colorize(PLAYER_COLORS[piece])
    else
      piece.colorize(COLORS[@color_index])
    end
  end

  def print_board
    input_color = :light_black
    board_color = COLORS[@color_index]
  
    separator_line_color = board_color
  
    puts "    7 | 8 | 9  ".colorize(input_color)
    puts "   #{'---+'.colorize(separator_line_color)}---+---".colorize(input_color)
    puts "    4 | 5 | 6  ".colorize(input_color)
    puts "   #{'---+'.colorize(separator_line_color)}---+---".colorize(input_color)
    puts "    1 | 2 | 3  ".colorize(input_color)
    puts
  
    @board.each_with_index do |row, i|
      puts "    #{colorized_cell(i, 0)} #{'|'.colorize(board_color)} #{colorized_cell(i, 1)} #{'|'.colorize(board_color)} #{colorized_cell(i, 2)}  "
      puts "   #{'---+---+---'.colorize(separator_line_color)}".colorize(board_color) unless i == 2
    end
    puts
  end
  
  

  def make_move
    loop do
      print "#{@current_player}'s turn" .colorize(PLAYER_COLORS[@current_player]) + ". Enter the cell number (1-9): "
      cell = gets.chomp.to_i
      if valid_move?(cell)
        row, col = CELL_MAPPING[cell]
        @board[row][col] = @current_player
        break
      else
        puts "Invalid move. Try again."
      end
    end
  end

  def valid_move?(cell)
    CELL_MAPPING.key?(cell) && @board[CELL_MAPPING[cell][0]][CELL_MAPPING[cell][1]] == ' '
  end

  def check_game_over
    check_winner || check_tie
  end

  def check_winner
    winning_combinations = [
      [[0, 0], [0, 1], [0, 2]], # rows
      [[1, 0], [1, 1], [1, 2]],
      [[2, 0], [2, 1], [2, 2]],
      [[0, 0], [1, 0], [2, 0]], # columns
      [[0, 1], [1, 1], [2, 1]],
      [[0, 2], [1, 2], [2, 2]],
      [[0, 0], [1, 1], [2, 2]], # diagonals
      [[0, 2], [1, 1], [2, 0]]
    ]

    winning_combinations.any? do |combo|
      combo.all? { |row, col| @board[row][col] == @current_player }
    end
  end

  def check_tie
    @board.flatten.none? { |cell| cell == ' ' } && !check_winner
  end

  def switch_player
    @current_player = (@current_player == 'X') ? 'O' : 'X'
  end
end


def display_winner_art(winner)
    if winner == 'X'
puts "                            .:^!7?Y5PGBB###&&&&&&&&&&&&&###BGGP5J?7~^:                              
                      .^7JPB#####BBGGPPPPPPPPPGGBB#BGGGPPPPPGGGBB#####BG5J!:                        
                    .Y#@&BPYY5PGB####&&&&&&&&&########&&&&&&&&&&####BGPPPB&&#Y^                     
                   :B@G!~^~G&&#BBGGPPPPP55555555555555555555PPPPPPGGB#&&G!~7P@@Y.                   
                   Y@#^:^^7&@&BGP5555555555555555555555555555555555PGB&@@?^^^7&@J                   
 :?5GGGGGGGGGPY!.  P@B7~^^^~?5B#&&&&&&&&&&####BBBBGBBBBBBB#####&&&&&#BPJ!^^^^^G@G  .!YPGGGGGGGGG5?: 
!&&5J????????YG@#^ P@#J?77~~^^^^~!7??JJYY55PPGGGBBBBBBGGGGPPPP5Y?7!~~^^^^~~!77#@? ^B@GYJ???????J5&&7
G@5~!7?JJJJJ?7!5@5 5@#YYJ?7777!!~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~~~!!77??JJJJ#@5 Y@P!7?JJJJJ?7!~Y@B
P@P775&&###&&Y7Y@G J@&YYJ?77777777?JJ?7!777!!!!!!!!!!!!!!!!!!7JJJJ?JJJJJYYYYYY&@? P@57Y#&###&&P77P@P
?@B775@G:::B@P??@&.!@@5YJ?7777!~7G&@@&#57!777777777777777777Y#&@@&#5YYYYYYYYY5@@~ &@J?P@#:::P@P77B@J
^@&?7?@&.  ?@#J7G@5?@@PYJ?7777!~B@@@@@@@#Y!!7777777777777?5#@@@@@@@&YYYYYYYYYG@@?Y@B7JB@J  .#@???&@^
 G@577B@?  .#@???PG#@@????7777!~5@@@@@@@@@&P?7777777777?5&@@@@@@@@@BYYYYYYYYYB@&#BP??5@&:  7@B775@G 
 7@#?7Y@#.  ~@@5J??J#@#YY??777!~~?G@@@@@@@@@&P?777777?P&@@@@@@@@@#PYYYYYYYYYY&@BJ??J5&@!  .#@???#@7 
  B@P77G@Y   ~G&&###&@@5YJ?7777~~~~7B@@@@@@@@@&GJ77?P&@@@@@@@@@#P5YYYYYYYYYYP@@&###&&G~   Y@G775@B  
  ~@@Y7?#@7    :~!!!7&@GYJ?7777~~~~^JPB@@@@@@@@@@GG&@@@@@@@@@#P555YYYYYYYYYY#@?!!!!~:    7@#?7J&@~  
   ?@#J7?&@7         5@&YY??777!~~~^?555G@@@@@@@@@@@@@@@@@&5J5555YYYYYYYYYY5@@7         7@&?7J#@?   
    J@#Y7?#@?        ~@@PYJ?7777^7YY5555YYP&@@@@@@@@@@@@&P?^Y5555YYYYYYYYYYB@B.        J@#?7J#@?    
     ?@&5?7G@B~       P@#YJ??777!7J?7Y55?!7P@@@@@@@@@@@@P7~!5555YYYYYYYYYY5@@7       ~B@G7?5&@?     
      ~#@????#@?~     ^@@PYJ??777~^?JY555G&@@@@@@@@@@@@@@#JJ5555YYYYYYYYYY#@?      ~P@#J7JG@#!      
       .Y@&PJ?YB@B?:   Y@&5J???77!!JYJ5G&@@@@@@@@@@@@@@@@@@&B55YYYYYYYYYYG@@^   :?B@#Y?JP&@Y.       
         ^5@&GY?JP#&GJ~^B@#YJ??777!^!Y&@@@@@@@@@BYYB@@@@@@@@@&B5YYYYYYYY5@@?.~JG&#PJ?YG&@5^         
           :J#@#PY?J5B##&@@BYJ??77?P&@@@@@@@@@BY7777JP@@@@@@@@@@B5YYYYYY#@@?##B5J?YP#@#J:           
              ~YB&&B5YJ55G@@GYJ?JG&@@@@@@@@@GJ777777^?PB@@@@@@@@@@B5YYYB@&PP5JY5B&&BY~.             
                 ^75B#&#BGB@@GY?#@@@@@@@@&P?77777777!J55PB@@@@@@@@@&YYB@@GPB#&#B5?^                 
                     :~7YPG#@@???@@@@@@&5!~!7777777777??JJYG&@@@@@@BYB@@#GPY7~:                     
                            ^B@#55G##B5?~~~~7777777777????JYYGB##BPYB@&~                            
                             .5@@PJ???777!~~~77777777????JYYYYYYYJY#@?^                             
                               7&@#5J???777!~!77777?????JYYYYYYYYP&@5.                              
                                .Y@@B5J?????7777???????JYYYYYYY5#@&7                                
                                  ^5@@B5J????????????JYYYYYYY5B@@Y.                                 
                                    ^Y&@#PYJ???????JJYYYYYYP#@&J:                                   
                                     .5@@@@BPYJJJJJYYYY5PB&@&@#?.                                   
                                    :#@????#@@&##BBB##&@&#P7~7G@&^                                  
                                    .5@&5!^~!?Y5GGBBGPY?7~^^!J#@?:                                  
                                      :5@@BJ777!!!!~~~~!77JG@@P!                                    
                                        :G@&YYYYYYYYYYYYYY#@?:                                      
                                         ?@@Y?JJJJJYYYYYY5@@7                                       
                                        7&@BJ77777?YYYYYYYB@&!                                      
                                      !G@&PJ7!~777?JYYYYYYYG&@P~                                    
                                   .?B@&GJ?7!~~777??JYYYYYYYYG&@G7.                                 
                             !5PPPG&@#PJ?7!~~~!7777??JYYYYYYYYYP&@#PPPPPJ^                          
                            P@#5#@@#5J77!~~~~~777777??JYYYYYYYYYYP#@@#5P@@?                         
                           ^@@?~&@G??77!~~~~~!7777777??JYYYYYYYYYYYG@&!:P@B                         
                           ^@@Y~P@@GY?!~~~~~~777777777??JYYYYYYYYY5#@#~~G@B                         
                           ~@@P?!75&@&G5J?7!!7777777777??JYYYY5PB&@#5!7JB@B.                        
                          .^B@&5?7~!?5B&&&&#BGGPP5555PPPPGB#&&&&BP?77J5G@@5^:                       
                          .^~J#@&PJ?!^^~!?J5PGBBB####BBBBGGPYJ?7!7J5PB@@G?^^:                       
                           .^^^7P#@&BY?7~~^^!!!!!!!!!!!!!!!77?JY5B&@&B5!^^^:                        
                             .::^^!JPB&&&#BGGPPP55Y555PPPGGB#&&&#B5?~^^^:.                          
                                ..:::^~!7JYPGGGBBB##BBBGGGPPY?7~^^:::..                             
                                     .....:::::^^^^^^^^^::::::....                                  "
    else
puts "                            .:^!7?Y5PGBB###&&&&&&&&&&&&&###BGGP5J?7~^:                              
                      .^7JPB#####BBGGPPPPPPPPPGGBB#BGGGGPPPPGGGBB#####BG5J!:                        
                    .Y#@#BPYY5PGB####&&&&&&&&&########&&&&&&&&&&####BGGPPB&&#Y^                     
                   :B@G!~^~G&&#BBGGPPPPP55555555555555555555PPPPPPGGB#&&G!~7P@@Y.                   
                   Y@#^:^^7&@&BGP5555555555555555555555555555555555PGB&@@?^^^7&@J                   
 :?5GGGGGGGGGPY!.  P@#7~^^^~?5B#&&&&&&&&&&####BBBBGBBBBBBB#####&&&&&#BPJ!^^^^^G@G  .!YPGGGGGGGGG5?: 
!&&5J??J????JYG@#^ P@#J?77~~^^^^~!7??JJYY55PPGGGBBBBBBGGGGPPPP5Y?7!~~^^^^~~!77#@? ^B@GYJ????J??J5&&7
G@5~!7?JJJJJ?7!5@5 5@#YYJ?7777!!~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~~~!!77??JJJJ#@5 Y@P!7?JJJJJ?7!~Y@B
P@P775&&###&&Y7Y@G J@&YYJ?77777777777777777!!!!!!!!!!!!!!!!77?????JJJJJJYYYYYY&@? P@57Y#&###&&P77P@P
?@B775@G:::B@P??@&.!@@5YJ?7777!~~~~!!!!!777777777???777777777?JYYYYYYYYYYYYYY5@@~ &@J?P@#:::P@P77B@J
^@&?7?@&.  ?@#J7G@5?@@PYJ?7777!~~~~~~~~~~~7JPGB##&&###BP5J?77?JYYYYYYYYYYYYYYG@@?Y@B7JB@J  .#@???&@^
 G@577B@?  .#@???PG#@@????7777!~~~~~~~~?P#@@@@@@@@@@@@@@@@&B5?7JYYYYYYYYYYYYYB@&#BP??5@&:  7@B775@G 
 7@#?7Y@#.  ~@@5J??J#@#YY??777!~~~~~!Y#@@@@@@@@@@@@@@@@@@@@@@&#P55YYYYYYYYYYY&@BJ??J5&@!  .#@???#@7 
  B@P77G@Y   ~G&&###&@@5YJ?7777~~~~J&@@@@@@@@@&BGPPPG#&@@@@@@@@@#5YYYYYYYYYYP@@&###&&G~   Y@G775@B  
  ~@@Y7?#@7    :~!!!7&@GYJ?7777~~~G@@@@@@@@BJ~:      .:!5#@@@@@@@&PYYYYYYYYY#@?!!!!~:    7@#?7J@@~  
   ?@&J7?&@7         5@&YY??777!~G@@@@@@@#!              .J&@@@@@@@PYYYYYYY5@@7         7@&?7J#@?   
    J@#Y7?#@?        ~@@PYJ?777!5@@@@@@@G.                 ^&@@@@@@&YYYYYYYB@B.        J@#?7J#@?    
     ?@&5?7G@B~       P@#YJ??77?&@@@@@@&:                   7@@@@@@@PYYYYY5@@7       ~B@G7?5&@?     
      ~#@????#@?~     ^@@PYJ??7J@@@@@@@B                    :&@@@@@@BYYYYY#@?      ~P@#J7JG@#!      
       .Y@&PJ?YB@B?:   Y@&5J??7?&@@@@@@&.                   !@@@@@@@GYYYYG@&^   :?B@#Y?JP&@Y.       
         ^5@&GY?JP#&GJ~^B@#YJ??7B@@@@@@@P                  :B@@@@@@@5YYY5@@?.~JG&#PJ?YG&@5^         
           :J#@#PY?J5B##&@@BYJ??J@@@@@@@@G^               !#@@@@@@@BYYYY#@@?##B5J?YP#@#J:           
              ~YB&&B5YJ55G@@GYJ??5@@@@@@@@@P7:        .^?B@@@@@@@@#YYYYB@&PP5JY5B&&BY~.             
                 ^75B#&#BGB@@GY???Y#@@@@@@@@@&BP5JJY5G#@@@@@@@@@@B5YYYB@@GPB#&#B5?^                 
                     :~7YPG#@@??????P&@@@@@@@@@@@@@@@@@@@@@@@@@#PYYYYB@@#GPY7~:                     
                            ^B@#5J??7?5#@@@@@@@@@@@@@@@@@@@@&B5YYYYYB@&~                            
                             .5@@PJ???77J5GB&@@@@@@@@@@@&#GPYYYYYY5#@?^                             
                               7&@#5J???777!!?YY555555YJJYYYYYYYYP&@5.                              
                                .Y@@B5J?????777777?????JYYYYYYY5#@&7                                
                                  ^5@@B5J????????????JYYYYYYY5B@@Y.                                 
                                    ^Y&@#PYJ???????JJYYYYYYP#@&J:                                   
                                     .5@@@@BPYJJJJJYYYY5PB&@&@#?.                                   
                                    :#@????#@@&##BBB##&@&#P7~7G@&^                                  
                                    .5@&5!^^!?Y5GGBBGPY?7~^^!J#@?:                                  
                                      :5&@BJ777!!!!~~~~!77JG@@P!                                    
                                        :G@&YYYYYYYYYYYYYY#@?:                                      
                                         ?@@Y?JJJJJYYYYYY5@@7                                       
                                        7&@BJ77777?YYYYYYYB@&!                                      
                                      !G@&PJ7!~777?JYYYYYYYG&@P~                                    
                                   .?B@&GJ?7!~~777??JYYYYYYYYG&@G7.                                 
                             !5PPPG&@#PJ?7!~~~!7777??JYYYYYYYYYP&@#PPPPPJ^                          
                            P@#5#@@#5J77!~~~~~777777??JYYYYYYYYYYP#@@#5P@@?                         
                           ^@@?~&@G??77!~~~~~!7777777??JYYYYYYYYYYYG@&!:P@B                         
                           ^@@5~P@@GY?!~~~~~~777777777??JYYYYYYYYY5#@#~~G@B                         
                           ^@@P?!75&@&G5J?7!!7777777777??JYYYY5PB&@#5!7JB@B.                        
                          .^B@&5?7~!?5B&&&&#BGGPP5555PPPPGB#&&&&B5?77J5G@@5^:                       
                          .^~Y#@&PJ?!^^~!?J5PGBBB####BBBBGGPYJ?7!7J5PB@@G?^^:                       
                           .^^^7P#@&BY?7~~^^!!!!!!!!!!!!!!!77?JY5B&@&B5!^^^:                        
                             .::^^!JPB&&&#BGGPPP55Y555PPPGGB#&&&#B5?~^^^:.                          
                                ..:::^~!7JYPGGGBBB##BBBGGGPPY?7~^^:::..                             
                                     .....:::::^^^^^^^^^::::::....                                  "
    end
  end


TicTacToe.new

