defmodule Storage.Repo.Migrations.Postings do
  use Ecto.Migration

  def change do
    create table(:postings) do
      add(:post_id, :string)
      add(:user_id, :string)
      add(:assigned_id, :string)
      add(:meta, :map)
      add(:game_id, :string)
      add(:details, :string)
      add(:state, :string)
      add(:expired_at, :naive_datetime)
      add(:meetup_at, :naive_datetime)
      add(:confirm_pay_amt, :string)
      add(:confirm_pay_type, :string)
      add(:complete_pay_amt, :string)
      add(:complete_pay_type, :string)
      add(:bonus_pay_amt, :string)
      add(:bonus_pay_type, :string)
      add(:bonus_req, :string)
      add(:level_req, :string)
      add(:class_req, :string)
      add(:user_count_req, :integer)
      add(:type_req, :string)
      timestamps()
    end

    create(unique_index(:postings, [:post_id]))
  end
end
