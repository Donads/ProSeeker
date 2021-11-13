# if Rails.env.production?
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.smtp_settings = {
  user_name: 'apikey', # This is the string literal 'apikey', NOT the ID of your API key
  password: Rails.application.credentials.sendgrid_api_key, # This is the secret sendgrid API key which was issued during API key creation
  domain: 'yandonadi.dev',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}

ActionMailer::Base.default_url_options = { host: 'yandonadi.dev' }
# end
