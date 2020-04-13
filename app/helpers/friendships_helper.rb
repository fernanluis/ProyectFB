module FriendshipsHelper
  # Since the Friendship controller depends on some helper methods we will create
  # them in the application helper.

  # checks whether a user has had a friend request sent to
  # them by the current user returning either true or false.
  def friend_request_sent?(user)
    current_user.friend_sent.exists?(sent_to_id: user.id, status: false)
  end

  # checks whether a user has sent a friend request to the current user returning either true or false.
  def friend_request_received?(user)
    current_user.friend_request_exists?(sent_by_id: user.id, status: false)
  end

  # Checks whether a user has had a friend request sent to them by the current user or
  # if the current user has been sent a friend request by the user returning either true or false
  def possible_friends?(user)
    request_sent = current_user.friend_sent.exists?(sent_to_id: user.id)
    request_received = current_user.friend_request.exists?(sent_by_id: user.id)

    return true if request_sent != request_received
    return true if request_sent == request_received && request_sent == true
    return false if request_sent == request_received && request_sent == false

  end

end
