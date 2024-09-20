defmodule BloggyWeb.PostLive.Show do
  use BloggyWeb, :live_view

  alias Bloggy.Blog
  # alias Bloggy.Comments
  alias Bloggy.Comments.Comment
  alias Bloggy.Accounts
  alias Bloggy.Likes

  @impl true
  def mount(%{"id" => post_id}, session, socket) do
    # post = Blog.get_post!(post_id)
    changeset = Bloggy.Comments.change_comment(%Comment{})
    user = Accounts.get_user_by_session_token(session["user_token"])
    commentor = Bloggy.Comments.get_commentor_with_post(post_id)
    like_count = Likes.count_likes(post_id)
    liked_post = Likes.get_like_by_user_post(user.id, post_id)

    # IO.inspect(socket, label: "Socket")
    # IO.inspect(commentor, label: "Mwenye Comment????")
    socket =
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      # |> assign(:post, post)
      |> assign(:changeset, changeset)
      |> assign(:edit_comment_changeset, Bloggy.Comments.change_comment(%Comment{}))
      |> assign(:current_user, user)
      |> assign(:show_modal, false)
      |> assign(:commentor, commentor)
      |> assign(:editing_comment_id, nil)
      |> assign(:show_like, false)
      |> assign(:like_count, like_count)
      |> assign(:liked_post, liked_post)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    IO.inspect(id, label: "ID")
    like_count = Bloggy.Likes.count_likes(id)
    IO.inspect(like_count, label: "Like Count")

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, Blog.get_post!(id))}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"

  @impl true
  def handle_event("show_modal", _, socket) do
    {:noreply, assign(socket, :show_modal, true)}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, :show_modal, false)}
  end

  def handle_event("submit_comment", %{"comment" => comment_params}, socket) do
    case Bloggy.Comments.create_comment(comment_params) do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment added successfully")
         |> push_redirect(to: Routes.post_show_path(socket, :show, socket.assigns.post.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("edit_comment", %{"id" => comment_id}, socket) do
    IO.puts("Edit comment event triggered")
    IO.inspect(comment_id, label: "Received comment ID")
    comment_id = String.to_integer(comment_id)
    comment = Bloggy.Comments.get_comment!(comment_id)
    changeset = Bloggy.Comments.change_comment(comment)
    IO.inspect(comment_id, label: "Updateeee Comment ID")

    {:noreply, assign(socket, edit_comment_changeset: changeset, editing_comment_id: comment_id)}
  end

  def handle_event("delete_comment", %{"id" => comment_id}, socket) do
    comment = Bloggy.Comments.get_comment!(comment_id)
    {:ok, _comment} = Bloggy.Comments.delete_comment(comment)

    {:noreply,
     socket
     |> put_flash(:info, "Comment deleted successfully.")
     |> assign(commentor: Bloggy.Comments.get_commentor_with_post(socket.assigns.post.id))}
  end

  def handle_event("submit_edit_comment", %{"comment" => comment_params}, socket) do
    # Fetching the changeset tied to the comment
    changeset = socket.assigns.edit_comment_changeset

    case Bloggy.Comments.update_comment(changeset.data, comment_params) do
      {:ok, edited_comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> assign(commentor: Bloggy.Comments.get_commentor_with_post(socket.assigns.post.id))
         |> assign(
           edit_comment_changeset: Bloggy.Comments.change_comment(edited_comment),
           editing_comment_id: nil
         )}

      #  |> push_redirect(to: Routes.post_show_path(socket, :show, socket.assigns.post.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, edit_comment_changeset: changeset)}
    end
  end

  def handle_event("show_like", %{"id" => post_id}, socket) do
    user_id = socket.assigns.current_user.id

    like_count = Bloggy.Likes.count_likes(post_id)
    # like_count = String.to_integer(like_count)

    liked_post = Bloggy.Likes.get_like_by_user_post(user_id, post_id)
    IO.inspect(liked_post, label: "Llllllllllliked Post")
    IO.inspect(like_count, label: "LiKKKKke Count")

    case liked_post do
      nil ->
        IO.inspect(like_count, label: "☑️☑️☑️☑️☑️☑️")
        Likes.create_like(%{user_id: user_id, post_id: post_id})
        {:noreply, assign(socket, show_like: true, like_count: like_count + 1)}

      %Bloggy.Likes.Like{} = like_record ->
        IO.inspect(like_count, label: "❌❌❌❌❌")
        Likes.delete_like(like_record)

        {:noreply,
         assign(socket, show_like: false, like_record: like_record, like_count: like_count - 1)}
    end
  end

  def get_likes(post_id) do
    Bloggy.Likes.count_likes(post_id)
  end
end
