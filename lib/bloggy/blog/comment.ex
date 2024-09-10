defmodule Bloggy.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do

    belongs_to :user, Bloggy.Accounts.User
    belongs_to :post, Bloggy.Blog.Post
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:user_id, :post_id, :description])
    |> validate_required([:user_id, :post_id, :description])
  end
end
