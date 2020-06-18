defmodule Storage.Repo.Migrations.Guilds do
  use Ecto.Migration

  def change do
    create table(:guild) do
      add(:name, :string)
      add(:payid, :text)
    end

    create(unique_index(:guild, [:name]))
  end
end
