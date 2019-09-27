defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Game.new()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
#      board = Tuple.to_list(game.board)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("getchar", %{"id" => id},socket) do
    game = socket.assigns[:game]
    char = Game.char(game, id)
    {:reply, {:ok, %{"char" => char}}, socket}
  end

  def handle_in("restart", payload, socket) do
    game = Game.new()
    socket = assign(socket, :game, game)
#    board = Tuple.to_list(game.board)
    {:reply, :ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (games:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end


  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
