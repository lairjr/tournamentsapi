defmodule TournamentsApi.Phases.Phase do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Draws.Draw
  alias TournamentsApi.Eliminations.Elimination
  alias TournamentsApi.Tournaments.Tournament
  alias TournamentsApi.Games.Game

  schema "phases" do
    field :title, :string
    field :type, :string
    field :order, :integer

    embeds_many :elimination_stats, EliminationStats, on_replace: :delete do
      field :title, :string
    end

    belongs_to :tournament, Tournament
    has_many :games, Game
    has_many :draws, Draw
    has_many :eliminations, Elimination

    timestamps()
  end

  @doc false
  def changeset(phase, attrs) do
    phase
    |> cast(attrs, [:title, :type, :order, :tournament_id])
    |> cast_embed(:elimination_stats, with: &elimination_stats_changeset/2)
    |> validate_required([:title, :type, :tournament_id])
  end

  defp elimination_stats_changeset(schema, params) do
    schema
    |> cast(params, [:title])
  end
end
