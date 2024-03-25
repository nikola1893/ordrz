require 'postmark'
class Order < ApplicationRecord
  belongs_to :user
  has_many :stops, dependent: :destroy
  accepts_nested_attributes_for :stops, allow_destroy: true
  after_create :generate_token, :generate_number, :send_confirmation_email_to_visitor
  after_update :send_confirmation_email_to_user, if: :status_changed_to_confirmed?

  def load_count
    stops.where(kind: 'load').count
  end

  def unload_count
    stops.where(kind: 'unload').count
  end

  private

  def status_changed_to_confirmed?
    saved_change_to_status? && status == 'confirmed'
  end

  def generate_token
    token = SecureRandom.hex(10)
    update(confirmation_token: token)
  end

  def generate_number
    prefix = SecureRandom.hex(3)
    datetime = Time.now.strftime("%d%m%y%H%M")
    update(number: "#{datetime}-#{prefix.upcase}")
  end

  def send_confirmation_email_to_visitor
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

  def send_confirmation_email_to_user
    client = Postmark::ApiClient.new(ENV['POSTMARK_API_TOKEN'])
    confirmation_link = "#{Rails.application.config.domain_name}/orders/#{confirmation_token}/view"
    
    client.deliver(
      from: 'info@deezpatch.com',
      to: self.user.email,
      subject: 'Your dispatch has been confirmed.',
      html_body: "<strong>Hello</strong> your dispatch has been confirmed, view your confirmation on this <a href='#{confirmation_link}'>link</a>",
      track_opens: true,
      message_stream: 'outbound')
  end
end
