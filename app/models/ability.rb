class Ability
  include CanCan::Ability

  # CanCanCan automatically integrates with ApplicationController and it assumes that you have a method in your ApplicationController called current_user

  # It is not necessary to create an Ability object (This is done automatically), but authorization rules must be set up. (i.e. Hooks - a before action handles the creation of the Ability object)

  def initialize(user)

    # We instantiate the user to User.new to avoid having user be nil if the user is not signed in - so methods can be called on it. We assume here that 'user' will be User.new if the user is not signed in.
    user ||= User.new

    # Gives superpowers to admin user by having the ability to manage all actions on all models
    # If a field is a boolean, Rails automatically creates a helper method with a question mark (alternatively, you can user user.admin, which references the value - true or false)
    can :manage, :all if user.admin?

    # Define alias_action instead of using :manage
    alias_action :create, :read, :update, :destroy, :to => :crud

    # Defining the ability to :manage (do anything) with a question
    can :crud, Question do |q|
      # This block returns true or false. This determines if the user is allowed to manage a question or not
      # user.persisted? ensures the user is actually logged in
      q.user == user && user.persisted?
    end

    can :crud, Answer do |a|
      # Both the author of the question and the author of the answer can CRUD an answer
      (a.question.user == user || a.user == user) && user.persisted?
    end

    # It is possible to define any action, i.e. can :edit / can :destroy ...etc

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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
