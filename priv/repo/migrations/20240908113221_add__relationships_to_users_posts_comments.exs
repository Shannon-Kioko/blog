defmodule Bloggy.Repo.Migrations.Add_RelationshipsToUsersPostsComments do
  use Ecto.Migration

  def change do
    # Drop existing constraints if they exist
    execute "ALTER TABLE posts DROP CONSTRAINT IF EXISTS posts_user_id_fkey;"
    execute "ALTER TABLE comments DROP CONSTRAINT IF EXISTS comments_user_id_fkey;"
    execute "ALTER TABLE comments DROP CONSTRAINT IF EXISTS comments_post_id_fkey;"

    # Alter the posts table to add the foreign key constraint
    alter table(:posts) do
      modify :user_id, references(:users, on_delete: :delete_all), from: :id
    end

    # Only create the index if it doesn't already exist
    execute """
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'posts_user_id_index'
      ) THEN
        CREATE INDEX posts_user_id_index ON posts (user_id);
      END IF;
    END
    $$;
    """

    # Alter the comments table only if needed
    alter table(:comments) do
      # Use :modify instead of :add if you only want to adjust existing columns
      modify :user_id, references(:users, on_delete: :delete_all), from: :id
      modify :post_id, references(:posts, on_delete: :delete_all), from: :id
    end

    # Create indexes if they don't already exist
    execute """
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'comments_user_id_index'
      ) THEN
        CREATE INDEX comments_user_id_index ON comments (user_id);
      END IF;
    END
    $$;
    """

    execute """
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'comments_post_id_index'
      ) THEN
        CREATE INDEX comments_post_id_index ON comments (post_id);
      END IF;
    END
    $$;
    """
  end
end
