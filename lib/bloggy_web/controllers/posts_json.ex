defmodule BloggyWeb.PostsJson do
  alias Bloggy.Blog.Post

  def index(%{posts: posts}) do
    %{data: for(post <- posts, do: data(post))}
  end

  def show(%{user_posts: posts}) do
    %{data: for(post <- posts, do: data(post))}
  end

  defp data(%Post{} = datum) do
    %{
      id: datum.id,
      title: datum.title,
      description: datum.description,
      user_id: datum.user_id,
    }
  end
end
