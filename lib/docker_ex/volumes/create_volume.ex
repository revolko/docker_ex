defmodule DockerEx.Volumes.CreateVolume do
  @moduledoc """
  The body of the POST /volumes/create
  """

  defstruct Name: nil, Driver: "local", DriverOpts: %{}, Labels: %{}, ClusterVolumeSpec: nil
end

defimpl Jason.Encoder, for: DockerEx.Volumes.CreateVolume do
  def encode(value, opts) do
    value
    |> Map.from_struct()
    |> Map.reject(fn {_k, v} -> is_nil(v) end)
    |> Jason.Encode.map(opts)
  end
end
