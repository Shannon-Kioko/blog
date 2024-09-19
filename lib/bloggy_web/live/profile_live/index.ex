defmodule BloggyWeb.ProfileLive.Index do
  use BloggyWeb, :live_view

  alias Bloggy.Accounts
  alias Bloggy.Blog
  alias Bloggy.Blog.Post
  # alias Bloggy.Accounts.Profile

  @impl true
  def mount(params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    user_posts = if user, do: Blog.get_post_by_user(user.id), else: []

    {
      :ok,
      socket
      |> assign(:current_user, user)
      |> assign(:user_posts, user_posts)
      |> assign(:editing_post_id, nil)
      # TODO: |> assign(uploaded_files: [])
      # |> allow_upload(:image, accept: ~w(.jpg .png .jpeg), max_entries: 1)
      # |> assign(socket, :profile_collection, list_profile())
    }

    # {:ok, redirect(socket, to: Routes.user_session_path(socket, :new))}
    # {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Blog.get_post!(id)
    {:ok, _} = Blog.delete_post(post)

    user_posts = Blog.get_post_by_user(socket.assigns.current_user.id)
    {:noreply, assign(socket, :user_posts, user_posts)}
  end

  @impl true
  def handle_event("edit", %{"id" => id}, socket) do
    IO.inspect(id, label: "Editing Post Triggereer")
    post = Blog.get_post!(id)
    changeset = Blog.change_post(post)
    {:noreply, assign(socket, editing_post_id: post.id, edit_post_changeset: changeset)}
  end

  def handle_event("submit_edit_post", %{"post" => post_params}, socket) do
    post = Blog.get_post!(socket.assigns.editing_post_id)

    case Blog.update_post(post, post_params) do
      {:ok, _post} ->
        user_posts = Blog.get_post_by_user(socket.assigns.current_user.id)

        {
          :noreply,
          socket
          |> put_flash(:info, "Post updated successfully.")
          |> assign(:user_posts, user_posts)
          |> assign(:editing_post_id, nil)
          # |> push_redirect(to: Routes.profile_index_path(socket, :index, post))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Post")
    |> assign(:post, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # # defp apply_action(socket, :new, _params) do
  # #   socket
  # #   |> assign(:page_title, "New Profile")
  # #   |> assign(:profile, %Profile{})
  # # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Profile")
  #   |> assign(:profile, nil)
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   profile = Accounts.get_profile!(id)
  #   {:ok, _} = Accounts.delete_profile(profile)

  #   {:noreply, assign(socket, :profile_collection, list_profile())}
  # end

  # defp list_profile do
  #   Accounts.list_profile()
  # end
end
