defmodule DockerEx.Exec do
  @moduledoc """
  SDK for /containers/{id}/exec and /exec endpoints
  """
  alias DockerEx.Client
  alias DockerEx.Exec.CreateExecInstance
  alias DockerEx.Exec.StartExecInstance

  @doc """
  Creates exec instance.

  Exec instances are used to run commands inside containers.

  ## Parameters

   * `container_id` - ID or name of container
   * `create_exec_body` - request body content

  ## Examples

      iex> DockerEx.Exec.create_exec_instance("container_name", %DockerEx.Exec.CreateExecInstance{})
      {:ok,
       %{
          "Id" => "exec instance ID"
       }}

  """
  @doc since: "0.1.0"
  def create_exec_instance(container_id, create_exec_body = %CreateExecInstance{}) do
    Client.post("/containers/#{container_id}/exec", Jason.encode!(create_exec_body))
  end

  @doc """
  Starts exec instance.

  Executes the command defined by the exec instance.

  ## Parameters

   * `id` - ID of exec instance
   * `start_exec_body` - request body content

  ## Examples

      iex> DockerEx.Exec.start_exec_instance("exec_instance_id", %DockerEx.Exec.StartExecInstance{})
      {:ok,
       %{
         "CanRemove" => false,
         "ContainerID" => "b21325d82a48ff78c12d227806730d35f60f03fca861eb39942a5a882e524ebd",
         "DetachKeys" => "",
         "ExitCode" => nil,
         "ID" => "f1ed1f229c676528d13c17f39c01686583f40ca7a80d19a7d211d694bb5d9ef9",
         "OpenStderr" => false,
         "OpenStdin" => false,
         "OpenStdout" => false,
         "Pid" => 0,
         "ProcessConfig" => %{
           "arguments" => ["hello"],
           "entrypoint" => "echo",
           "privileged" => false,
           "tty" => false,
           "user" => "user:user"
         },
         "Running" => false
       }}

  """
  @doc since: "0.1.0"
  def start_exec_instance(id, start_exec_body = %StartExecInstance{}) do
    Client.post("/exec/#{id}/start", Jason.encode!(start_exec_body))
  end

  @doc """
  Inspects exec instance.

  ## Parameters

   * `id` - ID of exec instance

  ## Examples

      iex> DockerEx.Exec.inspect_exec_instance("exec_instance_id")
      {:ok, %{ ... }}

  """
  @doc since: "0.1.0"
  def inspect_exec_instance(id) do
    Client.get("/exec/#{id}/json")
  end
end
