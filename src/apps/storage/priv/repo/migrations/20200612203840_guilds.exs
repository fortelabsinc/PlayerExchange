defmodule Storage.Repo.Migrations.Guilds do
  use Ecto.Migration

  def change do
    create table(:guilds) do
      add(:guild_id, :string)
      add(:name, :string)
      add(:owner, :string)
      add(:pay_id, :string)
      add(:image, :string)
      add(:description, :string)
      add(:members, :map)
      add(:games, :map)
      add(:active, :boolean)
      add(:meta, :map)
      timestamps()
    end

    create(unique_index(:guilds, [:guild_id]))
  end
end
