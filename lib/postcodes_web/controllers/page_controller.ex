defmodule PostcodesWeb.PageController do
  use PostcodesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
