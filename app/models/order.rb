require 'postmark'
class Order < ApplicationRecord
  belongs_to :user
  has_many :stops, dependent: :destroy
  accepts_nested_attributes_for :stops, allow_destroy: true
  after_create :send_confirmation_email

  private

  def send_confirmation_email
    client = Postmark::ApiClient.new(ENV['POSTMARK_API_TOKEN'])
    confirmation_link = "#{Rails.application.config.domain_name}/orders/#{confirmation_token}/view"

    client.deliver(
      from: 'info@deezpatch.com',
      to: self.email,
      subject: 'You have a new dispatch.',
      html_body: "<strong>Hello</strong> please confirm the transport order at this <a href='#{confirmation_link}'>link</a>",
      track_opens: true,
      message_stream: 'outbound')
  end
end
