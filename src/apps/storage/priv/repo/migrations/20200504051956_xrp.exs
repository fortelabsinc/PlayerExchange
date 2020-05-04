defmodule Storage.Repo.Migrations.Xrp do
  use Ecto.Migration

  def change do
    create table(:xrp) do
      add(:address, :string)
      add(:derivation, :string)
      add(:mnemonic, :string)
      add(:privatekey, :string)
      add(:publickey, :string)
    end

    create(unique_index(:xrp, [:address]))
  end
end
