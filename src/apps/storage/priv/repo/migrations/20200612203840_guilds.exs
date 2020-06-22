defmodule Storage.Repo.Migrations.Guilds do
  use Ecto.Migration

  def change do
    create table(:guild) do
      add(:guild_id, :string)
      add(:name, :string)
      add(:owner, :string)
      add(:pay_id, :string)
      add(:image, :string)
      add(:description, :string)
      add(:members, :map)
      add(:games, {:array, :string})
      add(:active, :boolean)
      add(:meta, :map)
      timestamps()
    end

    create(unique_index(:guild, [:guild_id]))
  end
end
