defmodule DockerEx.Images do
  @moduledoc """
  SDK for /images endpoints
  """

  alias DockerEx.Client
  alias DockerEx.Utils

  @doc """
  Lists existing images.

  ## Options

  The options are optional query parameters of the `GET /images/json` endpoint.
  See: `https://docs.docker.com/reference/api/engine/version/v1.53/#tag/Image/operation/ImageList`

  ## Examples

    iex> DockerEx.Images.list_images()
    {:ok, [{ ... }]}

  """
  @doc since: "0.1.0"
  def list_images(opts \\ []) do
    query_parameters = Utils.encode_query([], opts)

    "/images/json"
    |> Utils.maybe_query_params(query_parameters)
    |> Client.get()
  end

  @doc """
  Builds Docker image from a GIT repository.

  Currently, only building from public remote (tested with GitHub repo)
  is supported. The Dockerfile must be present in the root of the repo
  (remote cannot handle relative paths for inner Dockerfiles).

  ## Parameters

   * `:remote` - URL to a repository with Dockerfile
      The repository must be public since the authorization to a private
      repository is not yet implemented.
   * `:t` - The name of the image to be built.
      Can be provided as `name:tag` or as `name`.
      In the second case, the `tag` is `default`.

  ## Options

  The options are optional query parameters of the `POST /build` endpoint.
  See: `https://docs.docker.com/reference/api/engine/version/v1.53/#tag/Image/operation/ImageBuild`

  ## Examples

    iex> DockerEx.Images.build_image("https://github.com/revolko/vegetation.git", "vegetation")
    {:ok, [{ ... }]}

  """
  @doc since: "0.1.0"
  def build_image(remote, t, opts \\ []) do
    query_parameters = Utils.encode_query([remote: remote, t: t], opts)

    # build accepts only raw dockerfile or git repo url (ending with git)
    # this struggles with inner Dockerfiles using relatives path inside the repo
    "/build"
    |> Utils.maybe_query_params(query_parameters)
    |> Client.post_streamed("")
  end

  @doc """
  Pulls an image from a registry.

  Currently, only default DockerHub registry is supported. The image
  must be publicly available.

  ## Parameters

   * `from_image` - name of the image in the registry

  ## Options

  The options are optional query parameters of the `POST /images/create` endpoint.
  See: `https://docs.docker.com/reference/api/engine/version/v1.53/#tag/Image/operation/ImageCreate`

  ## Examples

    iex> DockerEx.Images.create_image("fedora")
    {:ok, [{ ... }]}

  """
  @doc since: "0.1.0"
  def create_image(from_image, opts \\ []) do
    query_parameters = Utils.encode_query([fromImage: from_image], opts)

    "/images/create"
    |> Utils.maybe_query_params(query_parameters)
    |> Client.post_streamed("")
  end
end
