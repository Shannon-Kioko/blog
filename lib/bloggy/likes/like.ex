defmodule Bloggy.Likes.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    belongs_to :user, Bloggy.Accounts.User
    belongs_to :post, Bloggy.Blog.Post

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:user_id, :post_id])
    |> validate_required([:user_id])

    # |> validate_required([:user_id, :post_id])
  end
end
