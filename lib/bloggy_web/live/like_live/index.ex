defmodule BloggyWeb.LikeLive.Index do
  use BloggyWeb, :live_view

  alias Bloggy.Likes
  alias Bloggy.Likes.Like

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :likes, list_likes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Like")
    |> assign(:like, Likes.get_like!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Like")
    |> assign(:like, %Like{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Likes")
    |> assign(:like, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    like = Likes.get_like!(id)
    {:ok, _} = Likes.delete_like(like)

    {:noreply, assign(socket, :likes, list_likes())}
  end

  defp list_likes do
    Likes.list_likes()
  end
end
