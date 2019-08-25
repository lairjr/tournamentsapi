defmodule TournamentsApiWeb.TournamentGameControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Organizations
  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentGame

  @create_attrs %{
    away_score: 10,
    datetime: "2019-08-25T16:59:27.116Z",
    home_score: 20,
    location: "some location"
  }
  @update_attrs %{
    away_score: 20,
    datetime: "2019-08-25T16:59:27.116Z",
    home_score: 30,
    location: "another location"
  }

  def fixture(:tournament_game) do
    attrs = map_tournament_phase_id(@create_attrs)
    {:ok, tournament_game} = Tournaments.create_tournament_game(attrs)
    tournament_game
  end

  def map_tournament_phase_id(attrs \\ %{}) do
    {:ok, organization} =
      Organizations.create_organization(%{name: "some organization", slug: "some-slug"})

    tournament_attrs = Map.merge(%{name: "some tournament"}, %{organization_id: organization.id})
    {:ok, tournament} = Tournaments.create_tournament(tournament_attrs)

    tournament_phase_attrs =
      Map.merge(%{title: "some phase", type: "stadings"}, %{tournament_id: tournament.id})

    {:ok, tournament_phase} = Tournaments.create_tournament_phase(tournament_phase_attrs)

    Map.merge(attrs, %{tournament_phase_id: tournament_phase.id})
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tournament_games", %{conn: conn} do
      attrs = map_tournament_phase_id(@create_attrs)
      conn = get(conn, Routes.tournament_game_path(conn, :index, attrs.tournament_phase_id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tournament_game" do
    test "renders tournament_game when data is valid", %{conn: conn} do
      attrs = map_tournament_phase_id(@create_attrs)

      conn =
        post(conn, Routes.tournament_game_path(conn, :create, attrs.tournament_phase_id),
          tournament_game: attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tournament_game_path(conn, :show, attrs.tournament_phase_id, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end
  end

  describe "update tournament_game" do
    setup [:create_tournament_game]

    test "renders tournament_game when data is valid", %{
      conn: conn,
      tournament_game: %TournamentGame{id: id} = tournament_game
    } do
      conn =
        put(
          conn,
          Routes.tournament_game_path(
            conn,
            :update,
            tournament_game.tournament_phase_id,
            tournament_game
          ),
          tournament_game: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn =
        get(
          conn,
          Routes.tournament_game_path(conn, :show, tournament_game.tournament_phase_id, id)
        )

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end
  end

  describe "delete tournament_game" do
    setup [:create_tournament_game]

    test "deletes chosen tournament_game", %{conn: conn, tournament_game: tournament_game} do
      conn =
        delete(
          conn,
          Routes.tournament_game_path(
            conn,
            :delete,
            tournament_game.tournament_phase_id,
            tournament_game
          )
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(
          conn,
          Routes.tournament_game_path(
            conn,
            :show,
            tournament_game.tournament_phase_id,
            tournament_game
          )
        )
      end
    end
  end

  defp create_tournament_game(_) do
    tournament_game = fixture(:tournament_game)
    {:ok, tournament_game: tournament_game}
  end
end
