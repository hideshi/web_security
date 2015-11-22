defmodule WebSecurity.Mailer do
  use Mailgun.Client,
    domain: Application.get_env(:web_security, :mailgun_domain),
    key: Application.get_env(:web_security, :mailgun_key)

  @from "postmaster@sandbox37ff1d9dc5df4bc3bd0d481c19b45463.mailgun.org"

  def send_email(email, subject, message) do
    send_email to: email,
               from: @from,
               subject: subject,
               text: message
  end
end
