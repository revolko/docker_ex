defmodule DockerEx.Volumes do
  @moduledoc """
  SDK for /volumes endpoints.
  """
  alias DockerEx.Client
  alias DockerEx.Utils
  alias DockerEx.Volumes.CreateVolume

  @doc """
  List volumes.

  ## Options

  The options are optional query parameters of the `GET /volumes` endpoint.
  See: `https://docs.docker.com/reference/api/engine/version/v1.52/#tag/Volume/operation/VolumeList`

  ## Examples

      iex> DockerEx.Volumes.list_volumes()
      {:ok, 
       %{
          "Volumes" => [
             %{
               "CreatedAt" => "2026-03-18T20:24:43+01:00",
               "Driver" => "local",
               "Labels" => nil,
               "Mountpoint" => "/var/lib/docker/volumes/once-proxy/_data",
               "Name" => "once-proxy",
               "Options" => nil,
               "Scope" => "local"
             }
          ],
          "Warnings" => nil
       }
      }

  """
  @doc since: "0.1.1"
  def list_volumes(opts \\ []) do
    query_parameters = Utils.encode_query([], opts)

    "/volumes"
    |> Utils.maybe_query_params(query_parameters)
    |> Client.get()
  end

  @doc """
  Inspect an existing volume.

  ## Parameters

   * `id` - ID or name of the volume

  ## Examples

      iex> DockerEx.Volumes.inspect_volume("volume")
      {:ok,
       %{
         "CreatedAt" => "2026-04-07T21:22:10+02:00",
         "Driver" => "local",
         "Labels" => %{},
         "Mountpoint" => "/var/lib/docker/volumes/volume/_data",
         "Name" => "volume",
         "Options" => %{},
         "Scope" => "local"
       }}

  """
  @doc since: "0.1.1"
  def inspect_volume(id) do
    "/volumes/#{id}"
    |> Client.get()
  end

  @doc """
  Create a new volume.

  ## Parameters

   * `create_body` - request body content

  ## Examples

      iex> DockerEx.Volumes.create_volume(%DockerEx.Volumes.CreateVolume{Name: "volume"})
      {:ok,
       %{
         "CreatedAt" => "2026-04-07T21:22:10+02:00",
         "Driver" => "local",
         "Labels" => %{},
         "Mountpoint" => "/var/lib/docker/volumes/volume/_data",
         "Name" => "volume",
         "Options" => %{},
         "Scope" => "local"
       }}

  """
  @doc since: "0.1.1"
  def create_volume(create_body = %CreateVolume{}) do
    case Jason.encode(create_body) do
      {:ok, create_body_json} ->
        "/volumes/create"
        |> Client.post(create_body_json)

      {:error, error} ->
        {:error, DockerEx.Error.new(error)}
    end
  end

  @doc """
  Delete volume.

  ## Parameters

   * `id` - ID or name of the volume

  ## Options

  The options are optional query parameters of the `DELETE /volumes/{id}` endpoint.
  See: `https://docs.docker.com/reference/api/engine/version/v1.52/#tag/Volume/operation/VolumeDelete`

  ## Examples

      iex> DockerEx.Volumes.delete_volume("volume")
      {:ok, ""}

  """
  @doc since: "0.1.1"
  def delete_volume(id, opts \\ []) do
    query_parameters = Utils.encode_query([], opts)

    "/volumes/#{id}"
    |> Utils.maybe_query_params(query_parameters)
    |> Client.delete()
  end
end
