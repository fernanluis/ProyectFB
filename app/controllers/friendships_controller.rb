class FriendshipsController < ApplicationController
  # Since the Friendship controller depends on some helper methods we will create
  # them in the application helper.

  include ApplicationHelper

  # Since this friendships controller create method is a nested route under
  # the users resource the route created provides the parameter user_id for use within this function.
  def create
    # Disallow the ability to send yourself a friend request
    return if current_user.id == params[:user_id]
    # Disallow the ability to send friend request more than once to same person
    return if friend_request_sent?(User.find(params[:user_id]))
    # Disallow the ability to send friend request to someone who already sent you one
    return if friend_request_received?(User.find(params[:user_id]))

    @user = User.find(params[:user_id])
    # current_user.friend_sent.build() creates a new record in the Friendship table
    # supplying the value of sent_by_id as that of the current user using the
    # friend_sent association between the User model and Friendship model.
    @friendship = current_user.friend_sent.build(sent_to_id: params[:user_id])
    if @friendship.save
      flash[:success] = "Friend Request Sent!"
      @notification = new_notification(@user, current_user.id, 'friendRequest')
      @notification.save
    else
      flash[:danger] = "Friend Request Failed!"
    end
    redirect_back(fallback_location: root_path)
  end

  # updates the friendship record in the Friendship table setting the status of the record to true
  # which we used to signify that the users are friends.
  def accept_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id],
                                      sent_to_id: current_user.id, status:false)
    return unless @friendship # return if no record is found

    @friendship.status = true # record is update
    if @friendship.save # record is update and save
      flash[:success] = "Friend Request Accepted!"

      # Once the original record is updated and saved a duplicate record is created.
      # This duplicate record will have the inverse value for sent_by_id and sent_to_id.
      # Esto facilita la realización de tareas de amistad y comprobaciones de bases de datos
      # para determinar las listas de amigos.
      @friendships2 = current_user.friend_sent.build(sent_to_id: params[:user_id], status = true)
      @friendships2.save
    else
      flash[:danger] = "Friend Request could not be accepted!"
    end
    redirect_back(fallback_location: root_path)
  end
  # For example: For example, Pepe sends Moni a friend request. Moni accepts the friend request.
  # Upon accepting the friend request another friend request is made automatically.
  # But instead this time it will be as if Moni had sent Pepe a friend request and Pepe
  # had accepted it.

  def decline_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship # return if no record is found
    @friendship.destroy
    flash[:success] = "Friend Request Declined!"
    redirect_back(fallback_location: root_path)
  end
end
