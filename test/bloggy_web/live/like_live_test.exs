defmodule BloggyWeb.LikeLiveTest do
  use BloggyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bloggy.LikesFixtures

  @create_attrs %{count: 42}
  @update_attrs %{count: 43}
  @invalid_attrs %{count: nil}

  defp create_like(_) do
    like = like_fixture()
    %{like: like}
  end

  describe "Index" do
    setup [:create_like]

    test "lists all likes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.like_index_path(conn, :index))

      assert html =~ "Listing Likes"
    end

    test "saves new like", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.like_index_path(conn, :index))

      assert index_live |> element("a", "New Like") |> render_click() =~
               "New Like"

      assert_patch(index_live, Routes.like_index_path(conn, :new))

      assert index_live
             |> form("#like-form", like: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#like-form", like: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.like_index_path(conn, :index))

      assert html =~ "Like created successfully"
    end

    test "updates like in listing", %{conn: conn, like: like} do
      {:ok, index_live, _html} = live(conn, Routes.like_index_path(conn, :index))

      assert index_live |> element("#like-#{like.id} a", "Edit") |> render_click() =~
               "Edit Like"

      assert_patch(index_live, Routes.like_index_path(conn, :edit, like))

      assert index_live
             |> form("#like-form", like: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#like-form", like: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.like_index_path(conn, :index))

      assert html =~ "Like updated successfully"
    end

    test "deletes like in listing", %{conn: conn, like: like} do
      {:ok, index_live, _html} = live(conn, Routes.like_index_path(conn, :index))

      assert index_live |> element("#like-#{like.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#like-#{like.id}")
    end
  end

  describe "Show" do
    setup [:create_like]

    test "displays like", %{conn: conn, like: like} do
      {:ok, _show_live, html} = live(conn, Routes.like_show_path(conn, :show, like))

      assert html =~ "Show Like"
    end

    test "updates like within modal", %{conn: conn, like: like} do
      {:ok, show_live, _html} = live(conn, Routes.like_show_path(conn, :show, like))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Like"

      assert_patch(show_live, Routes.like_show_path(conn, :edit, like))

      assert show_live
             |> form("#like-form", like: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#like-form", like: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.like_show_path(conn, :show, like))

      assert html =~ "Like updated successfully"
    end
  end
end
