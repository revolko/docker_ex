defmodule DockerEx.Containers do
  @moduledoc """
  SDK for /containers endpoints
  """
  alias DockerEx.Client

  def get_containers(opts \\ []) do
    query_parameters =
      Keyword.keys(opts)
      |> Enum.map(fn key -> "#{Atom.to_string(key)}=#{Keyword.get(opts, key)}" end)
      |> Enum.join("&")

    Client.get("/containers/json?#{query_parameters}")
  end
end
