defmodule WebSecurity.Mailer do
  use Mailgun.Client,
    domain: Application.get_env(:web_security, :mailgun_domain),
    key: Application.get_env(:web_security, :mailgun_key),
    mode: :test,
    test_file_path: "/tmp/mailgun.json"

  @from "hideshi.ogoshi@gmail.com"

  def send_email(email, subject, message) do
    send_email to: email,
               from: @from,
               subject: subject,
               text: message
  end
end
