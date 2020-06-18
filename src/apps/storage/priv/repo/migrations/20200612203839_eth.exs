defmodule Storage.Repo.Migrations.Eth do
  use Ecto.Migration

  def change do
    create table(:eth) do
      add(:address, :string)
      add(:mnemonic, :text)
      add(:privatekey, :text)
      add(:publickey, :text)
      add(:meta, :map)
      timestamps()
    end

    create(unique_index(:eth, [:address]))
  end
end
