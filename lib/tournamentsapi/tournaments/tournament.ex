defmodule TournamentsApi.Tournaments.Tournament do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Organizations.Organization
  alias TournamentsApi.Tournaments.TournamentGame
  alias TournamentsApi.Tournaments.TournamentGroup
  alias TournamentsApi.Tournaments.TournamentTeam

  schema "tournaments" do
    field :name, :string
    field :link, :string
    field :team_stats_structure, :map

    belongs_to :organization, Organization

    has_many :games, TournamentGame    
    has_many :groups, TournamentGroup 
    has_many :teams, TournamentTeam

    timestamps()
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :link, :team_stats_structure, :organization_id])
    |> validate_required([:name])
  end
end
