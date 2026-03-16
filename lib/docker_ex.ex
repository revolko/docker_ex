defmodule DockerEx do
  @moduledoc """
  Docker engine API SDK.

  ## Struct parameters

  Some of the functions accept a struct as parameter. The struct
  parameters are parsed to JSON and put as a request body. Other
  parameters are encoded as query parameters.

  The main reason for distinguishing request body parameters from query
  parameters are default parameters. Both, request body and query can
  have default parameters and if all are put to `opts` parameter it
  would be complex to parse them out correctly.

  ## Path parameters validation

  The library does NOT handle validation/encoding of path parameters.
  Namely, IDs that can be represented as hash or proper names.

  The reasoning is:
   * if used locally, users already have access to the underlying
     engine API.
   * if the library is exposed by another service, the service
     should take care of correct validation of user inputs (e.g.
     that container id cannot be `json/all` for
     `DockerEx.Containers.inspect_container/2` -- instead of inspecting
     a container it would list all containers).

  Note, query parameters are properly encoded according to [RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986)
  """
end
