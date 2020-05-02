defmodule Storage.Auth.EmailTemplate do
  use AccessPassBehavior

  def confirmation_email() do
    tls = Application.get_env(:storage, :http_base, "http")
    port = Application.get_env(:storage, :portal_port, 8180)
    server = Application.get_env(:storage, :dns_name, "localhost")

    """
    <a href="#{tls}://#{server}:#{port}/portal/commands/v1/auth/confirm?confirm_id=<%= conf_key %>">Please confirm you access</a>
    """
  end
end
