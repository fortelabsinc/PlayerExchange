defmodule Storage.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:user_id, :string)
      add(:username, :string, size: 50)
      add(:meta, :map)
      add(:email, :string, size: 50)
      add(:password_hash, :string)
      add(:successful_login_attempts, :integer)
      add(:confirm_id, :string)
      add(:password_reset_key, :string)
      add(:password_reset_expire, :integer)
      add(:confirmed, :boolean)
      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:user_id]))
    create(unique_index(:users, [:username]))
  end
end
