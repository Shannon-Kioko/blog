defmodule Bloggy.LikesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bloggy.Likes` context.
  """

  @doc """
  Generate a like.
  """
  def like_fixture(attrs \\ %{}) do
    {:ok, like} =
      attrs
      |> Enum.into(%{})
      |> Bloggy.Likes.create_like()

    like
  end
end
