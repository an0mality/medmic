class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)

      unless user.blocks
        if user.admin?
          can :manage, :all
        end

        if (user.vpch || user.mse || user.feed || user.moderator || user.onko || user.spid || user.rmis || user.frmr)
          can :manage, NotifyMessage
        end

         if (user.vpch || user.onko || user.spid)
           can :manage, [Analysis, Registry]
         end

        if user.feed
          can :manage , [Recipe, PatientFeed]
        end

        if user.moderator
          can :manage , [Sector, Doctor]
        end

        if user.mse && !user.mz
          can :manage, PrgRhb
          can :manage, MsePatient
        end

        if user.frmr
          can :manage, [FrmrOrganization, FrmrFap, FrmrDocument]
          can :read , [FrmrDoctor, FrmrSpeciality, FrmrPosition]
        end

        if user.mz&& user.frmr
          can :manage, [FrmrDoctor, FrmrDocumentType, FrmrQuality, FrmrPosition, FrmrSpeciality]
        end

      else
        can :read, Document
      end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end

  
end
