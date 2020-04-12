defmodule GoChampsApiWeb.TeamControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.Helpers.TournamentHelpers
  alias GoChampsApi.Teams
  alias GoChampsApi.Teams.Team

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:team) do
    {:ok, team} =
      @create_attrs
      |> TournamentHelpers.map_tournament_id()
      |> Teams.create_team()

    team
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create team" do
    @tag :authenticated
    test "renders team when data is valid", %{conn: conn} do
      create_attrs = TournamentHelpers.map_tournament_id(@create_attrs)
      conn = post(conn, Routes.v1_team_path(conn, :create), team: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.v1_team_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.v1_team_path(conn, :create), team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team" do
    setup [:create_team]

    @tag :authenticated
    test "renders team when data is valid", %{conn: conn, team: %Team{id: id} = team} do
      conn = put(conn, Routes.v1_team_path(conn, :update, team), team: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.v1_team_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, team: team} do
      conn = put(conn, Routes.v1_team_path(conn, :update, team), team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team" do
    setup [:create_team]

    @tag :authenticated
    test "deletes chosen team", %{conn: conn, team: team} do
      conn = delete(conn, Routes.v1_team_path(conn, :delete, team))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.v1_team_path(conn, :show, team))
      end
    end
  end

  defp create_team(_) do
    team = fixture(:team)
    {:ok, team: team}
  end
end
