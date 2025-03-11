require 'base64'
require 'openssl'
require 'cgi'

class DiscourseSsoController < ApplicationController
  def sso
    discourse_url = ENV['DISCOURSE_URL']
    secret = ENV['DISCOURSE_SSO_SECRET']

    if discourse_url.blank?
      Rails.logger.error "DISCOURSE_URL is missing!"
      render plain: "Server misconfiguration: Missing Discourse URL", status: :internal_server_error
      return
    end

    if secret.blank?
      Rails.logger.error "DISCOURSE_SSO_SECRET is missing!"
      render plain: "Server misconfiguration: Missing SSO secret", status: :internal_server_error
      return
    end

    sso_payload = params[:sso]
    sig = params[:sig]

    if sso_payload.blank? || sig.blank?
      # If SSO parameters are missing, redirect to the Discourse login page
      redirect_to "#{discourse_url}/login"
    else
      # Proceed with the SSO authentication process
      unless valid_signature?(sso_payload, sig, secret)
        render plain: "Invalid SSO request", status: :unauthorized
        return
      end

      # Ensure the user is logged in on the portal
      if current_user.nil?
        redirect_to login_path, alert: "Please log in to continue"
        return
      end

      user_data = {
        nonce: extract_nonce(sso_payload),
        external_id: current_user.id,
        email: current_user.email,
        username: current_user.username,
        admin: current_user.admin? ? "true" : "false",
        moderator: current_user.admin? ? "true" : "false"
      }

      return_sso = generate_sso_response(user_data, secret)

      redirect_to "#{discourse_url}/session/sso_login?sso=#{return_sso[:sso]}&sig=#{return_sso[:sig]}"
    end
  end

  private

  # Verify Discourse SSO signature
  def valid_signature?(sso_payload, sig, secret)
    expected_sig = OpenSSL::HMAC.hexdigest("sha256", secret, sso_payload)
    expected_sig == sig
  end

  # Extract nonce from SSO payload
  def extract_nonce(sso_payload)
    decoded = Base64.decode64(sso_payload)
    CGI.parse(decoded)["nonce"].first
  end

  # Generate SSO response
  def generate_sso_response(user_data, secret)
    query = user_data.to_query
    encoded = Base64.strict_encode64(query)
    sig = OpenSSL::HMAC.hexdigest("sha256", secret, encoded)
    { sso: CGI.escape(encoded), sig: sig }
  end
end