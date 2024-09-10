defmodule Bloggy.Repo.Migrations.MakePhoneNotNull do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :phone, :citext, null: false
      modify :first_name, :citext, null: false
      modify :last_name, :citext, null: false
    end
  end
end
