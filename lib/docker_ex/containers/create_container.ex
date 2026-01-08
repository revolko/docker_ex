defmodule DockerEx.Containers.CreateContainer do
  @moduledoc """
  The body of the POST /containers/create endpoint
  """

  @derive {Jason.Encoder, only: [:Image, :ExposedPorts, :HostConfig, :NetworkingConfig]}
  @enforce_keys [:Image]
  defstruct [:Image, ExposedPorts: %{}, HostConfig: %{}, NetworkingConfig: %{}]
end
