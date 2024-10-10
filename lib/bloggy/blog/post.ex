defmodule Bloggy.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :description, :user_id]}
  schema "posts" do
    field :description, :string
    field :title, :string
    field :image, :string

    belongs_to :user, Bloggy.Accounts.User
    has_many :comments, Bloggy.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :user_id, :image])
    |> validate_required([:title, :description, :user_id, :image])
  end
end
