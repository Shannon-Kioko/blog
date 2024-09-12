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

    IO.inspect(commentor, label: "Mwenye Comment????")
    {:ok, assign(socket, post: post, changeset: changeset, current_user: user, show_modal: false, commentor: commentor)}
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
end
