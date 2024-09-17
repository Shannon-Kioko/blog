defmodule BloggyWeb.PostLive.Show do
  use BloggyWeb, :live_view

  alias Bloggy.Blog
  # alias Bloggy.Comments
  alias Bloggy.Comments.Comment
  alias Bloggy.Accounts

  @impl true
  def mount(%{"id" => post_id}, session, socket) do
    post = Blog.get_post!(post_id)
    changeset = Bloggy.Comments.change_comment(%Comment{})
    user = Accounts.get_user_by_session_token(session["user_token"])
    # comments = Bloggy.Comments.get_comments_by_post(post_id)
    commentor = Bloggy.Comments.get_commentor_with_post(post_id)

    IO.inspect(socket, label: "Socket")
    # IO.inspect(commentor, label: "Mwenye Comment????")
    socket =
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:post, post)
      |> assign(:changeset, changeset)
      |> assign(:edit_comment_changeset, Bloggy.Comments.change_comment(%Comment{}))
      |> assign(:current_user, user)
      |> assign(:show_modal, false)
      |> assign(:commentor, commentor)
      |> assign(:editing_comment_id, nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
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
         |> assign(edit_comment_changeset: Bloggy.Comments.change_comment(edited_comment), editing_comment_id: nil)}
        #  |> push_redirect(to: Routes.post_show_path(socket, :show, socket.assigns.post.id))}


      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, edit_comment_changeset: changeset)}
    end
  end
end
