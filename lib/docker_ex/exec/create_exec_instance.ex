defmodule DockerEx.Exec.CreateExecInstance do
  @moduledoc """
  Create exec instance body
  """

  @derive {Jason.Encoder, only: [:User, :WorkingDir, :Cmd, :Privilaged]}
  @enforce_keys [:Cmd]
  defstruct [:User, :WorkingDir, Cmd: [], Privilaged: false]
end
