defmodule BloggyWeb.LikeLive.FormComponent do
  use BloggyWeb, :live_component

  alias Bloggy.Likes

  @impl true
  def update(%{like: like} = assigns, socket) do
    changeset = Likes.change_like(like)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"like" => like_params}, socket) do
    changeset =
      socket.assigns.like
      |> Likes.change_like(like_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"like" => like_params}, socket) do
    save_like(socket, socket.assigns.action, like_params)
  end

  defp save_like(socket, :edit, like_params) do
    case Likes.update_like(socket.assigns.like, like_params) do
      {:ok, _like} ->
        {:noreply,
         socket
         |> put_flash(:info, "Like updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_like(socket, :new, like_params) do
    case Likes.create_like(like_params) do
      {:ok, _like} ->
        {:noreply,
         socket
         |> put_flash(:info, "Like created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
