defmodule ConnectFourTest do
  use ExUnit.Case
  alias ConnectFour.Grid

  for {number, column, row} <- [{0, "B", 1}, {2, "D", 3}, {5, "F", 6}] do
    describe "on a grid with #{number} tokens in column #{column}" do
      setup do
        {:ok,
         grid:
           Grid.new()
           |> Stream.iterate(&Grid.drop_token(&1, unquote(column), :some_token))
           |> Stream.drop(unquote(number))
           |> Enum.at(0)}
      end

      test "a token placed in column #{column} ends up in row #{row}", %{grid: grid} do
        grid = Grid.drop_token(grid, unquote(column), :the_token)

        assert Grid.token_at(grid, "#{unquote(column)}#{unquote(row)}") == :the_token
      end
    end
  end

  describe "ConnectFour.winner/1" do
    test """
    The grid

    OOOOOOO
    OOOOOOO
    OOOOOOO
    OOOOOOO
    OOOOOOO
    YYYYOOO

    has Winner Y
    """ do
      winner =
        Grid.new()
        |> Grid.drop_token("A", :Y)
        |> Grid.drop_token("B", :Y)
        |> Grid.drop_token("C", :Y)
        |> Grid.drop_token("D", :Y)
        |> ConnectFour.winner()

      assert winner == :Y
    end

    test """
    The grid

    OOOOOOO
    OOOOOOO
    ROOOOOO
    ROOOOOO
    ROOOOOO
    ROOOOOO

    has winner R
    """ do
      winner =
        Grid.new()
        |> Grid.drop_token("A", :R)
        |> Grid.drop_token("A", :R)
        |> Grid.drop_token("A", :R)
        |> Grid.drop_token("A", :R)
        |> ConnectFour.winner()

      assert winner == :R
    end

    test "the empty grid has no winner" do
      assert Grid.new() |> ConnectFour.winner() == nil
    end

    test """
    The grid

    OOOOOOO
    OOOOOOO
    RYRROOO
    YYRYOOO
    RRYYOOO
    RYRYOOO

    has winner R
    """ do
      winner =
        Grid.new()
        |> Grid.drop_token("A", :R)
        |> Grid.drop_token("A", :R)
        |> Grid.drop_token("A", :Y)
        |> Grid.drop_token("A", :R)
        |> Grid.drop_token("B", :Y)
        |> Grid.drop_token("B", :R)
        |> Grid.drop_token("B", :Y)
        |> Grid.drop_token("B", :Y)
        |> Grid.drop_token("C", :R)
        |> Grid.drop_token("C", :Y)
        |> Grid.drop_token("C", :R)
        |> Grid.drop_token("C", :R)
        |> Grid.drop_token("D", :Y)
        |> Grid.drop_token("D", :Y)
        |> Grid.drop_token("D", :Y)
        |> Grid.drop_token("D", :R)
        |> ConnectFour.winner()

      assert winner == :R
    end

    test """
    The grid

    OOOOOOO
    OOOOOOO
    YYRYOOO
    YYRYOOO
    RRYROOO
    RYRYOOO

    has winner Y
    """ do
      winner =
        Grid.new()
        |> Grid.drop_token("A", :R)
        |> Grid.drop_token("A", :R)
        |> Grid.drop_token("A", :Y)
        |> Grid.drop_token("A", :Y)
        |> Grid.drop_token("B", :Y)
        |> Grid.drop_token("B", :R)
        |> Grid.drop_token("B", :Y)
        |> Grid.drop_token("B", :Y)
        |> Grid.drop_token("C", :R)
        |> Grid.drop_token("C", :Y)
        |> Grid.drop_token("C", :R)
        |> Grid.drop_token("C", :R)
        |> Grid.drop_token("D", :Y)
        |> Grid.drop_token("D", :R)
        |> Grid.drop_token("D", :Y)
        |> Grid.drop_token("D", :Y)
        |> ConnectFour.winner()

      assert winner == :Y
    end
  end
end
