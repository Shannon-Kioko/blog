defmodule BloggyWeb.PageController do
  use BloggyWeb, :controller

  def index(conn, _params) do
    # render(conn, "index.html")
    redirect(conn, to: "/posts")
  end

  def terms(conn, _params) do
    render(conn, "terms.html")
  end
end
