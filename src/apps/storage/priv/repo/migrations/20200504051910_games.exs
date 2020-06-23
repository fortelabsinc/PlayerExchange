defmodule Storage.Repo.Migrations.Games do
  use Ecto.Migration

  def change do
    create table(:games) do
      add(:game_id, :string)
      add(:name, :string)
      add(:owner, :string)
      add(:pay_id, :string)
      add(:image, :string)
      add(:fee, :string)
      add(:description, :string)
      add(:active, :boolean)
      add(:meta, :map)
      timestamps()
    end

    create(unique_index(:games, [:game_id]))
  end
end
