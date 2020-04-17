defmodule ConnectFour do
  defmodule Grid do
    @columns ["A", "B", "C", "D", "E", "F", "G"]
    @rows 1..6

    def new() do
      for column <- @columns, into: %{} do
        {column, []}
      end
    end

    def drop_token(grid, column, token) do
      Map.update!(grid, column, &[token | &1])
    end

    def token_at(grid, position) do
      {column, row} = read_position(position)
      grid[column] |> Enum.at(-row)
    end

    defp read_position(position) do
      {column, row} = String.split_at(position, 1)
      {column, String.to_integer(row)}
    end

    def rows do
      for row <- @rows do
        for column <- @columns do
          "#{column}#{row}"
        end
      end
    end

    def columns do
      for column <- @columns do
        for row <- @rows do
          "#{column}#{row}"
        end
      end
    end

    def up_right(row) do
      for {column, row} <- @columns |> Stream.with_index(row), row in @rows do
        "#{column}#{row}"
      end
    end

    def up_left(row) do
      for {column, row} <- @columns |> Enum.reverse() |> Stream.with_index(row), row in @rows do
        "#{column}#{row}"
      end
    end

    def down_right(row) do
      for {column, row} <- @columns |> Stream.take(row) |> Enum.reverse() |> Stream.with_index(1) do
        "#{column}#{row}"
      end
    end

    def down_left(row) do
      for {column, row} <- @columns |> Enum.slice(-row..0) |> Stream.with_index(1) do
        "#{column}#{row}"
      end
    end

    def diagonals do
      for row <- @rows do
        [down_right(row), down_left(row), up_right(row), up_left(row)]
      end
      |> Stream.flat_map(& &1)
    end
  end

  def winner(grid) do
    Stream.concat([Grid.rows(), Grid.columns(), Grid.diagonals()])
    |> Stream.flat_map(&Enum.chunk_every(&1, 4, 1, :discard))
    |> Stream.map(fn positions -> Enum.map(positions, &Grid.token_at(grid, &1)) end)
    |> Enum.find_value(&ConnectFour.is_winner/1)
  end

  def is_winner([a, a, a, a]), do: a

  def is_winner([_, _, _, _]), do: nil
end
