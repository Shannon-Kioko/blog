defmodule Bloggy.CommentsTest do
  use Bloggy.DataCase

  alias Bloggy.Comments

  setup_all do
    # Setup code that runs once before any tests
    # For example, create some shared comments
    {:ok}
  end

  describe "comments" do
    alias Bloggy.Comments.Comment

    import Bloggy.CommentsFixtures
    use Bloggy.DataCase, async: false

    @invalid_attrs %{}
    @valid_attrs %{
      body: "some comment",
      post_id: Bloggy.BlogFixtures.post_fixture().id,
      user_id: Bloggy.AccountsFixtures.user_fixture().id
    }

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Comments.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Comments.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{}

      assert {:ok, %Comment{} = comment} = Comments.create_comment(valid_attrs)
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{}

      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, update_attrs)
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)
      assert comment == Comments.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end
end
