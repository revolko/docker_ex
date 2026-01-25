defmodule DockerEx.Images do
  @moduledoc """
  SDK for /images endpoints
  """

  alias DockerEx.Client

  def list_images(all \\ "false") do
    Client.get("/images/json?all=#{all}")
  end

  @doc """
  Builds Docker image that can be later used for creating container.

  Currently, only bulding from remote (tested with GitHub repo) is supported.
  The Dockerfile must be present in the root of the repo (remote cannot
  handle relative paths for inner Dockerfiles).

  ## Options

   * `:remote_url` - URL to a repository with Dockerfile
      The repository must be public since the authorization to a private
      repository is not yet implemented.
   * `:name` - The name of the image to be build
   * `:tag` - The tag of the image. Default `tag` is "latest"

  ## Examples

    iex> DockerEx.Images.build_image("https://github.com/revolko/vegetation.git", "vegetation")
    {:ok, ""}
  """
  def build_image(remote_url, name, tag \\ "latest") do
    # build accepts only raw dockerfile or git repo url (ending with git)
    # this struggles with inner Dockerfiles using relatives path inside the repo
    Client.post_streamed("/build?remote=#{remote_url}&t=#{name}:#{tag}", "")
  end

  def create_image(from_image, tag \\ "latest") do
    Client.post_streamed("/images/create?fromImage=#{from_image}&tag=#{tag}", "")
  end
end
