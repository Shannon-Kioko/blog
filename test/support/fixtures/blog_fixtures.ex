defmodule Bloggy.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bloggy.Blog` context.
  """

  import Bloggy.AccountsFixtures #  alias the fixtures module
  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    user = user_fixture()
    {:ok, post} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        user_id: user.id
      })
      |> Bloggy.Blog.create_post()

    post
  end

end
