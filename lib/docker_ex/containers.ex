defmodule DockerEx.Containers do
  @moduledoc """
  SDK for /containers endpoints
  """
  alias DockerEx.Client
  alias DockerEx.Utils

  def get_containers(opts \\ []) do
    query_parameters = Utils.get_query_parameters(opts)

    Client.get("/containers/json?#{query_parameters}")
  end

  def create_container(image, opts \\ []) do
    query_parameters = Utils.get_query_parameters(opts)

    create_body = %{
      Image: image
    }

    Client.post("/containers/create?#{query_parameters}", Jason.encode!(create_body))
  end
end
