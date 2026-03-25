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

  @doc """
  Adds query parameters to the `path`.

  If there are no query parameters returns the `path`. Useful in
  combination with `DockerEx.Utils.encode_query/2` function.

  ## Parameters

   * `path` - the endpoint path
   * `query_params` - query parameters

  ## Examples

      iex> DockerEx.Utils.maybe_query_params("/endpoint", "param=value")
      "/endpoint?param=value"

      iex> DockerEx.Utils.maybe_query_params("/endpoint", "")
      "/endpoint"

  """
  @doc since: "0.1.0"
  def maybe_query_params(path, "") do
    path
  end

  def maybe_query_params(path, query_params) do
    "#{path}?#{query_params}"
  end
end
