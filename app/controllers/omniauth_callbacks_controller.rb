class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :auth, :authorization

  def facebook
  end

  def twitter
  end

  def add_email
  end

  private

  def auth
    if request.env['omniauth.auth']
      @auth = request.env['omniauth.auth']
    elsif session['devise.auth']
      @auth = OmniAuth::AuthHash.new(
        provider: session['devise.auth']['provider'], uid: session['devise.auth']['uid'],
        info: { email: params[:user][:email], name: session['devise.auth']['name'] })
    end
  end

  def authorization
    unless @auth
      set_flash_message(
        :notice,
        :failure,
        kind: "#{@auth.provider.capitalize}",
        reason: 'An unexpected error has occurred when logging in')
      redirect_to new_user_registration_url
    end

    @user = User.find_for_oauth(@auth)

    if @user.try(:persisted?)
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{@auth.provider.capitalize}") if is_navigational_format?
    elsif @auth.present?
      flash[:notice] = 'You should add your email'

    session['devise.auth'] = {
      provider: request.env['omniauth.auth'].provider,
      uid: request.env['omniauth.auth'].uid,
      name: request.env['omniauth.auth'].info[:name]
    }

    render 'authorization/add_email'
    end
  end
end