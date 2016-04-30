ActionMailer::Base.smtp_settings = {
  address:              "smtp.gmail.com",
  port:                 "587", # uses TCP
  enable_starttls_auto: true,
  authentication:       :plain,
  # When set as environmental variables, user_name and password are set on the operating system level
  # 
  user_name:            ENV["email_user_name"],
  password:             ENV["email_password"]
}
