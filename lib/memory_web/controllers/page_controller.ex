defmodule MemoryWeb.PageController do
  use MemoryWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def game(conn, %{"x" => x}) do
    x = String.downcase(x)
    render conn, x<>".html", name: x
  end
end
