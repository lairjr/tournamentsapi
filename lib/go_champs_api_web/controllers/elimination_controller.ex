defmodule GoChampsApiWeb.EliminationController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.Eliminations
  alias GoChampsApi.Eliminations.Elimination

  action_fallback GoChampsApiWeb.FallbackController

  plug GoChampsApiWeb.Plugs.AuthorizedElimination, :elimination when action in [:create]
  plug GoChampsApiWeb.Plugs.AuthorizedElimination, :eliminations when action in [:batch_update]
  plug GoChampsApiWeb.Plugs.AuthorizedElimination, :id when action in [:delete, :update]

  def create(conn, %{"elimination" => elimination_params}) do
    with {:ok, %Elimination{} = elimination} <-
           Eliminations.create_elimination(elimination_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.elimination_path(conn, :show, elimination))
      |> render("show.json", elimination: elimination)
    end
  end

  def show(conn, %{"id" => id}) do
    elimination = Eliminations.get_elimination!(id)
    render(conn, "show.json", elimination: elimination)
  end

  def update(conn, %{"id" => id, "elimination" => elimination_params}) do
    elimination = Eliminations.get_elimination!(id)

    with {:ok, %Elimination{} = elimination} <-
           Eliminations.update_elimination(elimination, elimination_params) do
      render(conn, "show.json", elimination: elimination)
    end
  end

  def batch_update(conn, %{"eliminations" => eliminations_param}) do
    with {:ok, eliminations} <- Eliminations.update_eliminations(eliminations_param) do
      render(conn, "batch_list.json", eliminations: eliminations)
    end
  end

  def delete(conn, %{"id" => id}) do
    elimination = Eliminations.get_elimination!(id)

    with {:ok, %Elimination{}} <- Eliminations.delete_elimination(elimination) do
      send_resp(conn, :no_content, "")
    end
  end
end
