require 'omniauth'

OmniAuth.config.logger = Rails.logger

require 'omniauth-github'
require 'omniauth-google-oauth2'
require 'omniauth-ldap'

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.application.config.samson.auth.github
    provider :github,
      ENV["GITHUB_CLIENT_ID"],
      ENV["GITHUB_SECRET"],
      scope: "user:email",
      client_options: {
        site:          "https://#{Rails.application.config.samson.github.api_url}",
        authorize_url: "https://#{Rails.application.config.samson.github.web_url}/login/oauth/authorize",
        token_url:     "https://#{Rails.application.config.samson.github.web_url}/login/oauth/access_token",
      }
  end

  if Rails.application.config.samson.auth.google
    provider OmniAuth::Strategies::GoogleOauth2,
      ENV["GOOGLE_CLIENT_ID"],
      ENV["GOOGLE_CLIENT_SECRET"],
      {
        name:   "google",
        scope:  "email,profile",
        prompt: "select_account",
      }
  end

  if Rails.application.config.samson.auth.ldap
    provider OmniAuth::Strategies::LDAP,
      title: Rails.application.config.samson.ldap.title,
      host: Rails.application.config.samson.ldap.host,
      port: Rails.application.config.samson.ldap.port,
      method: 'plain',
      base: Rails.application.config.samson.ldap.base,
      uid: Rails.application.config.samson.ldap.uid,
      bind_dn: Rails.application.config.samson.ldap.bind_dn,
      password: Rails.application.config.samson.ldap.password
  end

  if Rails.application.config.samson.auth.gitlab
    require 'omniauth-gitlab'
    provider :gitlab,
      ENV['GITLAB_APP_ID'],
      ENV['GITLAB_SECRET'],
      client_options: {
        site: ENV['GITLAB_SITE'],
        authorize_url: ENV['GITLAB_AUTHORIZE_URL'] || '/oauth/authorize',
        token_url: ENV['GITLAB_TOKEN_URL'] || '/oauth/token'
      }
  end
end
