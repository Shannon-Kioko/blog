defmodule Bloggy.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bloggy.Comments` context.
  """
  import Bloggy.AccountsFixtures

  @doc """
  Generate a comment.
  """

  def comment_fixture(attrs \\ %{}) do
    # Use user_fixture to create a user
    user = user_fixture()
    # Use post_fixture to create a post
    post = Bloggy.BlogFixtures.post_fixture()

    valid_attrs = %{body: "some comment", post_id: post.id, user_id: user.id}

    {:ok, comment} =
      attrs
      |> Enum.into(valid_attrs)
      |> Bloggy.Comments.create_comment()

    comment
  end
end
