defmodule Bloggy.Likes.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    field :count, :integer
    belongs_to :post, Bloggy.Blog.Post
    belongs_to :user, Bloggy.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:count])
    |> validate_required([:count])
  end
end
