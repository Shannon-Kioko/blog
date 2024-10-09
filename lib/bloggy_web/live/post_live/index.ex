defmodule BloggyWeb.PostLive.Index do
  use BloggyWeb, :live_view

  use Phoenix.HTML
  use Phoenix.HTML.SimplifiedHelpers

  alias Bloggy.Blog
  alias Bloggy.Blog.Post

  alias Bloggy.Accounts
  @impl true
  def mount(_params, session, socket) do
    IO.inspect(session, label: "session")
    user = Accounts.get_user_by_session_token(session["user_token"])
    # user_id = user.id
    # user_posts = Blog.get_post_by_user(user.id)
    # poster = Bloggy.Blog.get_post_with_user(id)
    IO.inspect(user, label: "user")

    {
      :ok,
      socket
      # |> assign(:posts, list_posts())
      # |> assign(:posts, Blog.list_posts_with_offset(0))
      |> assign(posts: Blog.list_posts_user_with_offset(0))
      |> assign(current_user: user)
      |> assign(:page_title, "#{user.first_name} Posts")
      |> assign(:show_like, false)
      |> assign(post_id: nil)
      |> assign(like_count: 0)
      |> assign(page: 0)

      #  |> assign(:post, nil)
      #  |> assign(:poster, poster)
      #  |> assign(user_posts: user_posts)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.inspect(params, label: "params in post")
    # post = Bloggy.Blog.get_post!(params["id"])
    # post_id = post.id

    # user_id = socket.assigns.current_user.id
    # liked = Bloggy.Likes.get_like_by_user_post(user_id, post_id)

    # # liked = Bloggy.Likes.
    # show_like =
    #   case liked do
    #     nil -> false
    #     "true" -> true
    #   end

    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Blog.get_post!(id))

    # |> assign(())
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("load-more", _, socket) do
    %{
      page: page,
      posts: posts
    } = socket.assigns

    next_page = page + 1

    {:noreply,
     assign(socket, posts: posts ++ Blog.list_posts_user_with_offset(next_page), page: next_page)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Blog.get_post!(id)
    {:ok, _} = Blog.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts())}
  end

  def handle_event("show_like", %{"post-id" => post_id}, socket) do
    IO.inspect(post_id, label: "Post IDDDDDDDddd")
    user_id = socket.assigns.current_user.id
    assign(socket, post_id: post_id)

    like_count = Bloggy.Likes.count_likes(post_id)
    # like_count = String.to_integer(like_count)

    liked_post = Bloggy.Likes.get_like_by_user_post(user_id, post_id)
    IO.inspect(liked_post, label: "Llllllllllliked Post")
    IO.inspect(like_count, label: "LiKKKKke Count")

    cond do
      liked_post == nil ->
        Bloggy.Likes.create_like(%{user_id: user_id, post_id: post_id})
        {:noreply, assign(socket, show_like: true, like_count: like_count + 1)}

      liked_post == nil ->
        Bloggy.Likes.delete_like(liked_post)
        {:noreply, assign(socket, show_like: false, like_count: like_count)}
    end

    # {:noreply, socket}
  end

  defp list_posts do
    Blog.list_posts()
  end

  def get_likes(post_id) do
    Bloggy.Likes.count_likes(post_id)
  end
end
