defmodule DockerEx.Exec do
  @moduledoc """
  SDK for /containers/{id}/exec and /exec endpoints
  """
  alias DockerEx.Client
  alias DockerEx.Exec.CreateExecInstance
  alias DockerEx.Exec.StartExecInstance

  def create_exec_instance(container_id, create_exec_body = %CreateExecInstance{}) do
    Client.post("/containers/#{container_id}/exec", Jason.encode!(create_exec_body))
  end

  def start_exec_instance(id, start_exec_body = %StartExecInstance{}) do
    Client.post("/exec/#{id}/start", Jason.encode!(start_exec_body))
  end

  def inspect_exec_instance(id) do
    Client.get("/exec/#{id}/json")
  end
end
