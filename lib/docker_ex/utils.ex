defmodule DockerEx.Utils do
  @moduledoc """
  Helpers and utilities for other modules
  """

  def get_query_parameters(opts) do
    Keyword.keys(opts)
    |> Enum.map(fn key -> "#{Atom.to_string(key)}=#{Keyword.get(opts, key)}" end)
    |> Enum.join("&")
  end
end
