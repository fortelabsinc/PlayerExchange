defmodule Storage.Repo.Migrations.Xrp do
  use Ecto.Migration

  def change do
    create table(:xrp) do
      add(:address, :string)
      add(:derivation, :text)
      add(:mnemonic, :text)
      add(:privatekey, :text)
      add(:publickey, :text)
    end

    create(unique_index(:xrp, [:address]))
  end
end
