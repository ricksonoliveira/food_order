defmodule FoodOrderWeb.PageControllerTest do
  use FoodOrderWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Hello Tailwind World"
  end
end
