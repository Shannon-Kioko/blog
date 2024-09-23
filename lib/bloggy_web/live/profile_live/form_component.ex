defmodule BloggyWeb.ProfileLive.FormComponent do
  alias Bloggy.Blog
  use BloggyWeb, :live_component

  alias Blog
  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = Blog.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(uploaded_files: [])
     |> assign(:image_preview, post.image)
     |> allow_upload(:image, accept: ~w(.jpg .png .jpeg), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Blog.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  # def handle_event("remove-upload", %{"ref" => ref}, socket) do
  #   {:noreply, cancel_upload(socket, :image, ref)}
  # end

  @impl true
  def handle_event("remove-upload", %{"ref" => ref}, socket) do
    {:noreply, update(socket, :uploads, &remove_upload(&1, ref))}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp remove_upload(uploads, ref) do
    %{
      uploads
      | image: %{
          entries: Enum.reject(uploads.image.entries, fn entry -> entry.ref == ref end)
        }
    }
  end

  defp save_post(socket, :edit, post_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:bloggy), "static", "uploads", Path.basename(path)])

        # File.cp!(path, Path.join(Application.app_dir(:bloggy), "priv/static/uploads"))
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}

    post_params = Map.put(post_params, "image", List.first(uploaded_files))

    case Blog.update_post(socket.assigns.post, post_params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_post(socket, :new, post_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:bloggy), "static", "uploads", Path.basename(path)])

        # File.cp!(path, Path.join(Application.app_dir(:bloggy), "priv/static/uploads"))
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}

    post_params = Map.put(post_params, "image", List.first(uploaded_files))

    case Blog.create_post(post_params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset.errors)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
