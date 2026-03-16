defmodule DockerEx.Containers do
  @moduledoc """
  SDK for /containers endpoints.

  Some of the functions accept a struct as parameter. The struct
  parameters are parsed to JSON and put as a request body. Other
  parameters are encoded as query parameters.

  The main reason for distinguishing request body parameters from query
  parameters are default parameters. Both, request body and query can
  have default parameters and if all are put to `opts` parameter it
  would be complex to parse them out correctly.
  """
  alias DockerEx.Client
  alias DockerEx.Utils
  alias DockerEx.Containers.CreateContainer

  @doc """
  Lists containers.

  ## Options

  The options are optional query parameters of the `GET /containers/json` endpoint.
  See: `https://docs.docker.com/reference/api/engine/version/v1.52/#tag/Container/operation/ContainerList`

  ## Examples

    iex> DockerEx.Containers.list_containers()
    {:ok, [{ ... }]}

  """
  @doc since: "0.1.0"
  def list_containers(opts \\ []) do
    query_parameters = Utils.encode_query([], opts)

    "/containers/json"
    |> Utils.maybe_query_params(query_parameters)
    |> Client.get()
  end

  @doc """
  Inspects an existing container.

  ## Parameters

   * `id` - container id

  ## Options

  The options are optional query parameters of the `GET /containers/{id}/json` endpoint.
  See: `https://docs.docker.com/reference/api/engine/version/v1.52/#tag/Container/operation/ContainerInspect`

  ## Examples

    iex> DockerEx.Containers.inspect_container("container_id")
    {:ok, %{ ... }}

  """
  @doc since: "0.1.0"
  def inspect_container(id, opts \\ []) do
    query_parameters = Utils.encode_query([], opts)

    "/containers/#{id}/json"
    |> Utils.maybe_query_params(query_parameters)
    |> Client.get()
  end

  @doc """
  Creates a new container.

  ## Parameters

   * `create_body` - request body content

  ## Options

  The options are optional query parameters of the `POST /containers/create` endpoint.
  See: `https://docs.docker.com/reference/api/engine/version/v1.52/#tag/Container/operation/ContainerCreate`

  ## Examples

    iex> DockerEx.Containers.create_container(%CreateContainer{}, name: "container_name")
    {:ok,
     %{
       "Id" => "container hash id",
       "Warnings" => []
     }}

  """
  @doc since: "0.1.0"
  def create_container(create_body = %CreateContainer{}, opts \\ []) do
    query_parameters = Utils.encode_query([], opts)

    "/containers/create"
    |> Utils.maybe_query_params(query_parameters)
    |> Client.post(Jason.encode!(create_body))
  end

  @doc """
  Starts container.

  ## Parameters

   * `id` - ID or name of the container

  ## Examples

    iex> DockerEx.Containers.start_container("container_name")
    {:ok, ""}
  """
  @doc since: "0.1.0"
  def start_container(id) do
    Client.post("/containers/#{id}/start", "")
  end

  @doc """
  Deletes container.

  ## Parameters

   * `id` - ID or name of the container

  ## Options

  The options are optional query parameters of the `DELETE /containers/{id}` endpoint.
  See: `https://docs.docker.com/reference/api/engine/version/v1.52/#tag/Container/operation/ContainerDelete`

  ## Examples

    iex> DockerEx.Containers.delete_container("test_cont")
    {:ok, ""}

  """
  @doc since: "0.1.0"
  def delete_container(id, opts \\ []) do
    query_parameters = Utils.encode_query([], opts)

    "/containers/#{id}"
    |> Utils.maybe_query_params(query_parameters)
    |> Client.delete()
  end
end
