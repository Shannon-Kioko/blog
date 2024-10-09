defmodule Bloggy.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Bloggy.Repo

  alias Bloggy.Blog.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(from(p in Post, order_by: [desc: p.inserted_at], preload: [:user]))
  end

  @doc """
    Returns the list of posts with offset and number of pages.
  """
  def list_posts_with_offset(page, per_page \\ 6) do
    Repo.all(
      from(p in Post, order_by: [desc: p.inserted_at], preload: [:user])
      |> paginate(page, per_page)
    )
  end

  @doc """
    Returns the list of posts and users with offset and number of pages.
  """
  def list_posts_user_with_offset(page, per_page \\ 6) do
    Repo.all(
      from(p in Post,
        join: u in assoc(p, :user),
        where: p.user_id == u.id,
        select: %{post: p, user: u},
        order_by: [desc: p.inserted_at],
        preload: [:user]
      )
      |> paginate(page, per_page)
    )
  end

  def paginate(query, page, per_page) do
    offset_by = page * per_page

    query
    |> limit(^per_page)
    |> offset(^offset_by)
  end

  @spec get_post!(any()) :: any()
  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @spec create_post() :: any()
  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def get_post_by_user(user_id) do
    Repo.all(
      from(p in Post,
        where: p.user_id == ^user_id,
        order_by: [desc: p.inserted_at],
        preload: [:user]
      )
    )
  end

  @doc """
  Gett post with the user
  """
  def get_post_with_user(post_id) do
    Repo.all(
      from(p in Post,
        join: u in assoc(p, :user),
        where: p.id == ^post_id,
        select: %{user: u, post: p}
      )
    )
  end
end
