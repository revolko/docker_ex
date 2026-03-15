defmodule DockerEx.Utils do
  @moduledoc """
  Helpers and utilities for other modules
  """

  @doc """
  Encodes parameters to a query string.

  The function sanitizes `optional` parameters by dropping duplicates
  defined in `mandatory`. That way users cannot redefine mandatory
  query parameter in `optional` keyword list.

  ## Parameters

   * `mandatory` - keyword list of mandatory query parameters
   * `optional` - keyword list of optional query parameters

  ## Examples

    iex> DockerEx.Utils.encode_query([from_image: "image_name"], [from_image: "not_image", size: 1])
    "from_image=image_name&size=1"
  """
  @doc since: "0.1.0"
  def encode_query(mandatory, optional) do
    (mandatory ++ Keyword.drop(optional, Keyword.keys(mandatory)))
    |> URI.encode_query(:rfc3986)
  end
end
