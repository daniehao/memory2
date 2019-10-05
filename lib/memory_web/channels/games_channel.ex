defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.BackupAgent

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = BackupAgent.get(name) || Game.new()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      BackupAgent.put(name, game)
      {:ok, %{"join" => name, "click" => game.click, "matched_id" => game.matched_id, "shown_id" => game.shown_id},socket}
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

  def handle_in("click", %{"id" => id, "click" => click}, socket) do
    name = socket.assigns[:name]
    game = socket.assigns[:game]
    game = %{game|click: click}
    shown_id = [id|game.shown_id]
    game = %{game|shown_id: shown_id}
    socket = assign(socket, :game, game)
    BackupAgent.put(name, game)
    {:reply, :ok, socket}
  end

  def handle_in("notmatch", payload, socket) do
    name = socket.assigns[:name]
    game = socket.assigns[:game]
    game = %{game|shown_id: []}
    socket = assign(socket, :game, game)
    BackupAgent.put(name, game)
    {:reply, :ok, socket}
  end

  def handle_in("match", %{"matched_id" => new_id}, socket) do
    name = socket.assigns[:name]
    game = socket.assigns[:game]
    matched_id = game.matched_id
    matched_id = [new_id|matched_id]
    |> List.flatten()
    game = %{game|matched_id: matched_id}
    game = %{game|shown_id: []}
    socket = assign(socket, :game, game)
    BackupAgent.put(name, game)
    {:reply, :ok, socket}
  end

  def handle_in("restart", payload, socket) do
    name = socket.assigns[:name]
    game = Game.new()
    socket = assign(socket, :game, game)
    BackupAgent.put(name, game)
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
