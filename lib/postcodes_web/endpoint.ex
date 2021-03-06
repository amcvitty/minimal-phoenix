defmodule PostcodesWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :postcodes
  use SiteEncrypt.Phoenix

  @impl Phoenix.Endpoint
  def init(_key, config) do
    {:ok, SiteEncrypt.Phoenix.configure_https(config)}
  end

  @impl SiteEncrypt
  def certification do
    SiteEncrypt.configure(
      client: :native,
      domains: ["amcvitty.fairuse.org", "www.amcvitty.fairuse.org"],
      emails: ["andy.mcvitty@gmail.com"],
      db_folder: Application.get_env(:postcodes, :cert_path, "tmp/site_encrypt_db"),
      directory_url:
        case Application.get_env(:postcodes, :cert_mode, "local") do
          "local" -> {:internal, port: 4002}
          "staging" -> "https://acme-staging-v02.api.letsencrypt.org/directory"
          "production" -> "https://acme-v02.api.letsencrypt.org/directory"
        end
    )
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_postcodes_key",
    signing_salt: "kxiLt7MV"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  def www_redirect(conn, _options) do
    if String.starts_with?(conn.host, "www.#{host()}") do
      conn
      |> Phoenix.Controller.redirect(external: "https://#{host()}")
      |> halt()
    else
      conn
    end
  end

  # Redirect all www requests to the root url
  plug :www_redirect

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :postcodes,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :postcodes
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug PostcodesWeb.Router
end
