defmodule Trot.Supervisor do
  @moduledoc false

  @doc false
  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc false
  def init([]) do
    import Supervisor.Spec

    priv_dir = Path.join(Application.app_dir(:trot), "priv")
    certfile = Path.join(priv_dir, "server.pem")
    keyfile = Path.join(priv_dir, "server.key")

    unless File.exists?(keyfile) do
      raise """
      No SSL key/cert found. Please run the following command:

      openssl req -new -newkey rsa:4096 -days 365 -nodes -x509  \
      -subj "/C=CN/ST=Shanghai/L=Changning/O=CreditX/CN=creditx.com" \
      -keyout priv/server.key -out priv/server.pem
      """
    end

    port = case Application.get_env(:trot, :port, 4000) do
      port when is_binary(port) -> String.to_integer(port)
      port -> port
    end
    router_module = Application.get_env(:trot, :router, Trot.NotFound)

    children = [
      Plug.Adapters.Cowboy2.child_spec(:https, router_module, [],
        [port: port, certfile: certfile, keyfile: keyfile]),
      Plug.Adapters.Cowboy2.child_spec(:http, router_module, [], [port: port+1])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
