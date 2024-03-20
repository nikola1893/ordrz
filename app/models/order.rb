require 'postmark'
class Order < ApplicationRecord
  belongs_to :user
  has_many :stops, dependent: :destroy
  accepts_nested_attributes_for :stops, allow_destroy: true
  after_create :send_confirmation_email

  private

  def send_confirmation_email
    client = Postmark::ApiClient.new('1f29c9d9-532a-4633-bddc-bcc92087e5ae')
    client.deliver(
      from: 'info@deezpatch.com',
      to: self.email,
      subject: 'Hello from Postmark',
      html_body: '<strong>Hello</strong> dear Postmark user.',
      track_opens: true,
      message_stream: 'outbound')
  end
end
