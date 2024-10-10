defmodule BloggyWeb.PostController do
  use Phoenix.Controller, formats: [:json]
  alias Bloggy.Blog

  def index(conn, _params) do
    posts = %{posts: Blog.list_posts()}
    IO.inspect(posts, label: "posts")
    json(conn, posts)
  end

  def show(conn, %{"id" => id}) do
    post = %{user_posts: Blog.get_post_by_user(id)}
    IO.inspect(post, label: "posts")
    json(conn, post)
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    {:ok, _post} = Blog.delete_post(post)
    conn
    |> put_status(:no_content)
  end

end
