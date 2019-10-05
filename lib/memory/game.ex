#My data layout for a game:
#  %{
#     board: Tuple of String
#     click: number of clicks
#     matched_id: list of matched id
#     shown_id: list of shown id
#  }

defmodule Memory.Game do
  def new do
    list_board = ["A","B","C","D","E","F","G","H"]
    |> List.duplicate(2)
    |> List.flatten()
    |> Enum.take_random(16)
    |> List.to_tuple()
    %{
      board: list_board,
      click: 0,
      matched_id: [],
      shown_id: []
    }
  end
  
  def char(game, id) do
    id = String.to_integer(id) -  1
    elem(game.board,id)
  end
end

