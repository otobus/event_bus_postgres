defmodule EventBus.Postgres.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :transaction_id, :uuid
      add :topic, :string
      add :data, :bytea
      add :initialized_at, :bigint
      add :occurred_at, :bigint
      add :source, :string
      add :ttl, :integer
    end

    create index(:events, ["occurred_at DESC"])
    create index(:events, [:topic])
    create index(:events, [:transaction_id])
  end
end
