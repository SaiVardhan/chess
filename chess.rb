require 'bundler/inline'
require 'trollop'

# gemfile do
# 	source 'https://rubygems.org'
# 	gem 'trollop'
# end

class Chess

  attr_accessor :piece, :position

  MOVES = {
 "knight" => 
      [[-1, -2],
      [-2, -1],
      [-2, 1],
      [-1, 2],
      [1, -2],
      [2, -1],
      [2, 1],
      [1, 2]],

 "rook" => [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ],

 "queen" => [
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1],
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]}

  def initialize(piece, position)
    @piece = piece.downcase
    @position = position.downcase
    if check_pos_piece(@piece,@position)
      get_possible_moves(@piece, @position)
    else
       p "Wrong parameters passed.Possible options ruby chess.rb -p 'KNIGHT' -s 'D2' "
       exit 1
    end
  end

  def check_pos_piece(piece, position)
    return true if position.length == 2 && MOVES.has_key?(piece)
  end

  def in_range(x,y)
     (x >= 1 && x <=8) && (y>= 1 && y <=8)
  end

  def get_possible_moves(piece, position)
   pos_points = position.split('')
   pos_points_x,pos_points_y = pos_points
   pos_points_x = pos_points_x.ord.to_i - 96
   p pos_points_x
   p pos_points_y
   if in_range(pos_points_x,pos_points_y.to_i)
      moves = get_positions(piece, pos_points_x, pos_points_y.to_i)
      final_outcome = moves.map {|s| (s[0].to_i+96).chr + s[1].to_s }.join(",")
      puts "Possible Moves are:: #{final_outcome}"
   else
    p "Moves not in range"
   end
  end

  def get_positions(p, pos_x, pos_y)
    p_moves = [] 
    if p!='knight'
      p_moves =   MOVES[p].map do |move|
        (1..8).map do |dist|
          new_x = pos_x + dist*move[0]
          new_y = pos_y + dist*move[1]
          [new_x, new_y] if in_range(new_x, new_y)
        end
      end.flatten(1)
    else
      p_moves = MOVES[p].map  do |move|
        new_x = pos_x + move[0]
        new_y = pos_y + move[1]
        [new_x, new_y] if in_range(new_x, new_y)
      end
    end 
    p_moves.compact
  end

end


if __FILE__ == $0
  opts = Trollop::options do
    opt :piece, "Piece - KNIGHT, ROOK, QUEEN", :type => String, :short => "p", :required => true
    opt :position, "SQUARE - a2,b2..", :type => String, :short => "s", :required => true
  end
end

chess = Chess.new(opts[:piece], opts[:position])

  