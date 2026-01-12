defmodule DockerEx.Exec.StartExecInstance do
  @moduledoc """
  Start exec instance body
  """

  @derive {Jason.Encoder, only: [:Detach, :Tty]}
  defstruct Detach: false, Tty: false
end

