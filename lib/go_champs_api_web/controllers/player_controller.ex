defmodule GoChampsApiWeb.PlayerController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.Players
  alias GoChampsApi.Players.Player

  action_fallback GoChampsApiWeb.FallbackController

  plug GoChampsApiWeb.Plugs.AuthorizedPlayer, :id when action in [:delete, :update]
  plug GoChampsApiWeb.Plugs.AuthorizedPlayer, :player when action in [:create]

  def index(conn, _params) do
    players = Players.list_players()
    render(conn, "index.json", players: players)
  end

  def create(conn, %{"player" => player_params}) do
    with {:ok, %Player{} = player} <- Players.create_player(player_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.v1_player_path(conn, :show, player))
      |> render("show.json", player: player)
    end
  end

  def show(conn, %{"id" => id}) do
    player = Players.get_player!(id)
    render(conn, "show.json", player: player)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Players.get_player!(id)

    with {:ok, %Player{} = player} <- Players.update_player(player, player_params) do
      render(conn, "show.json", player: player)
    end
  end

  def delete(conn, %{"id" => id}) do
    player = Players.get_player!(id)

    with {:ok, %Player{}} <- Players.delete_player(player) do
      send_resp(conn, :no_content, "")
    end
  end
end
