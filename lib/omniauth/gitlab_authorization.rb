class GitlabAuthorization
  def initialize(user_info, private_token)
    @user = user_info
  end

  def actived?
    @user["state"] == 'active'
  end

  def role_id
    if @user["is_admin"]
      Role::ADMIN.id
    else
      Role::DEPLOYER.id
    end
  end
end
