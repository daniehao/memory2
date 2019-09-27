#My data layout for a game:
#  %{
#     board: Tuple of String
#  }

defmodule Memory.Game do
  def new do
    list_board = ["A","B","C","D","E","F","G","H"]
    |> List.duplicate(2)
    |> List.flatten()
    |> Enum.take_random(16)
    |> List.to_tuple()
    %{
      board: list_board
    }
  end
  
  def char(game, id) do
    list_board = game.board
    id = String.to_integer(id) -  1
    elem(game.board,id)
  end
end

