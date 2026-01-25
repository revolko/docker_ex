defmodule DockerEx.Client do
  @moduledoc """
  Docker API client. Helper for sending requests to Docker Engine API.
  """

  require Logger

  defstruct headers: []

  def get(path) do
    {:ok, socket} =
      :gen_tcp.connect({:local, "/var/run/docker.sock"}, 0, [
        :binary,
        {:active, false},
        {:packet, :http_bin}
      ])

    :gen_tcp.send(
      socket,
      "GET #{path} HTTP/1.1\nHost: #{:net_adm.localhost()}\n\n"
    )

    {:ok, body} = do_recv(socket)
    Jason.decode(body)
  end

  def post(path, body, ignore_response_body \\ false) do
    {:ok, socket} =
      :gen_tcp.connect({:local, "/var/run/docker.sock"}, 0, [
        :binary,
        {:active, false},
        {:packet, :http_bin}
      ])

    :gen_tcp.send(
      socket,
      "POST #{path} HTTP/1.1\n" <>
        "Host: #{:net_adm.localhost()}\n" <>
        "Content-Type: application/json\n" <>
        "Content-Length: #{byte_size(body)}\n" <>
        "\n#{body}\n"
    )

    with {:ok, body} <- do_recv(socket) do
      case body do
        "" ->
          {:ok, ""}

        resp ->
          if ignore_response_body do
            {:ok, ""}
          else
            Jason.decode(resp)
          end
      end
    end
  end

  def delete(path) do
    {:ok, socket} =
      :gen_tcp.connect({:local, "/var/run/docker.sock"}, 0, [
        :binary,
        {:active, false},
        {:packet, :http_bin}
      ])

    :gen_tcp.send(
      socket,
      "DELETE #{path} HTTP/1.1\nHost: #{:net_adm.localhost()}\n\n"
    )

    do_recv(socket)
  end

  defp do_recv(socket), do: do_recv(socket, :gen_tcp.recv(socket, 0), %DockerEx.Client{})

  defp do_recv(socket, {:ok, {:http_response, {1, 1}, status, _}}, resp)
       when status >= 200 and status < 400 do
    do_recv(socket, :gen_tcp.recv(socket, 0), resp)
  end

  defp do_recv(socket, {:ok, {:http_response, {1, 1}, status, http_error}}, _resp)
       when status >= 400 do
    {:ok, error_details} = do_recv(socket)
    {:error, {status, http_error, Jason.decode!(error_details)}}
  end

  defp do_recv(socket, {:ok, {:http_header, _, header, _, value}}, resp) do
    do_recv(socket, :gen_tcp.recv(socket, 0), %DockerEx.Client{resp | headers: [{header, value}]})
  end

  defp do_recv(socket, {:ok, :http_eoh}, resp) do
    case :proplists.get_value(:"Transfer-Encoding", resp.headers) do
      "chunked" ->
        read_chunked_body(socket, [])

      :undefined ->
        case :proplists.get_value(:"Content-Length", resp.headers) do
          :undefined ->
            {:ok, ""}

          content_length ->
            bytes_to_read = String.to_integer(content_length)
            # TODO: figure out why this is needed
            :inet.setopts(socket, [{:packet, :raw}])
            :gen_tcp.recv(socket, bytes_to_read)
        end
    end
  end

  defp read_chunked_body(socket, acc) do
    :inet.setopts(socket, [{:packet, :line}])

    case :gen_tcp.recv(socket, 0) do
      {:ok, chunk_length} ->
        chunk_length = String.trim_trailing(chunk_length, "\r\n") |> String.to_integer(16)

        if chunk_length == 0 do
          {:ok, :erlang.iolist_to_binary(Enum.reverse(acc))}
        else
          :inet.setopts(socket, [{:packet, :raw}])
          {:ok, data} = :gen_tcp.recv(socket, chunk_length)
          # get rid of trailing \r\n
          :gen_tcp.recv(socket, 2)
          read_chunked_body(socket, [data | acc])
        end

      other ->
        {:error, other}
    end
  end
end
