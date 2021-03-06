class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 会員登録後の遷移先
  def after_sign_up_path_for(resource)
    user_path(params[:id])
  end

  def after_sign_in_path_for(resource)
    if user_signed_in?
      root_path
    else
      admin_path
    end
  end

  # ログアウト後の遷移先
  def after_sign_out_path_for(resource)
    if resource == :user
      root_path
    else
      new_admin_session_path
    end
  end

  protected

  # 会員登録時のストロングパラメーター
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :last_name_kana, :first_name_kana])
  end
end
