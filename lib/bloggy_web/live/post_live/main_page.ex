defmodule BloggyWeb.MainPageController do
  use BloggyWeb, :controller

  alias Bloggy.Accounts
  alias Bloggy.Blog

  def view(conn, _params) do
    user_token = conn.assigns["user_token"]
    IO.inspect(user_token, label: "userRRRRRtoken")

    case user_token do
      nil ->
        # Handle the case where there's no user_token, e.g., redirect to login
        conn
        |> put_flash(:error, "You need to log in to access this page.")
        |> redirect(to: Routes.user_session_path(conn, :new))

      _user_token ->
        user = Accounts.get_user_by_session_token(user_token)
        user_posts = if user, do: Blog.get_post_by_user(user.id), else: []

        render(conn, "main_page.html",
          posts: Blog.list_posts(),
          current_user: user,
          user_posts: user_posts
        )

        # render(conn, "main_page.html", posts: Blog.list_posts(), current_user: user, user_posts: user_posts)
    end
  end

  def handle_event("show_modal", %{"id" => id}, socket) do
  end
end
