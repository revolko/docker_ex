defmodule DockerEx.Containers.CreateContainer do
  @moduledoc """
  The body of the POST /containers/create endpoint
  """

  @derive {Jason.Encoder, only: [:image, :exposed_ports, :host_config]}
  @enforce_keys [:image]
  defstruct [:image, exposed_ports: %{}, host_config: %{}]
end
