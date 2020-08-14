defmodule Reporter.Repo.Migrations.CreateIncidents do
  use Ecto.Migration

  def change do
    create table(:incidents) do
      add(:source, :string)
      add(:description, :string, size: 100_000)
      add(:image, :string)
      add(:title, :string)
      timestamps()
    end
  end
end
