class OrderMailer < ApplicationMailer
  default from: 'noreply@deezpatch.com'

  def confirm
    mail(
      subject: 'Hello from Postmark',
      to: 'mitev.nkl@gmail.com',
      from: 'noreply@deezpatch.com',
      html_body: '<strong>Hello</strong> dear Postmark user.',
      track_opens: 'true',
      message_stream: 'outbound')
  end
end