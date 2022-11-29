class Ability
    include CanCan::Ability
  
    def initialize admin_user
        admin_user ||= AdminUser.new
        if admin_user.admin?
          can :manage, :all
        else
          can :manage, :all
          cannot :manage, AdminUser
          can :read, AdminUser
          cannot :manage, User
          can :read, User
        end
      end
end