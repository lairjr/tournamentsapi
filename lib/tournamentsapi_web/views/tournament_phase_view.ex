defmodule TournamentsApiWeb.TournamentPhaseView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.TournamentPhaseView

  def render("index.json", %{tournament_phases: tournament_phases}) do
    %{data: render_many(tournament_phases, TournamentPhaseView, "tournament_phase.json")}
  end

  def render("show.json", %{tournament_phase: tournament_phase}) do
    %{data: render_one(tournament_phase, TournamentPhaseView, "tournament_phase.json")}
  end

  def render("tournament_phase.json", %{tournament_phase: tournament_phase}) do
    %{id: tournament_phase.id, title: tournament_phase.title, type: tournament_phase.type}
  end
end