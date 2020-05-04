defmodule Storage.Repo.Migrations.Games do
  use Ecto.Migration

  def change do
    create table(:games) do
      add(:name, :string)
      add(:image, :string)
      add(:info, :string)
    end

    create(unique_index(:games, [:name]))
  end
end