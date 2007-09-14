class FriendshipController < ApplicationController
  before_filter :login_required, :setup_friends
  
  # Send a friend request
  def create
    Friendship.request(current_user, @friend)
    UserMailer.deliver_friend_request(
      :user => current_user,
      :friend => @friend,
      :user_url => user_path(current_user),
      :accept_url =>  url_for(:action => "accept",  :id => current_user),
      :decline_url => url_for(:action => "decline", :id => current_user)
    )
    flash[:notice] = "Friend request sent"
    redirect_to user_path(@friend)
  end
  
  def accept
    if current_user.requested_friends.include? @friend
      Friendship.accept(current_user, @friend)
      flash[:notice] = "Friendship with #{@friend.profile.full_name || @friend.login}"
    else
      flash[:error] = "No friendship request from #{@friend.profile.full_name || @friend.login}"
    end
    redirect_to hub_url
  end
  
  def decline
    if current_user.requested_friends.include? @friend
      Friendship.breakup(current_user, @friend)
      flash[:notice] = "Friendship with #{@friend.profile.full_name || @friend.login}"
    else
      flash[:error] = "No friendship request from #{@friend.profile.full_name || @friend.login}"
    end
    redirect_to hub_url
  end
  
  def cancel
    if current_user.pending_friends.include? @friend
      Friendship.breakup(current_user, @friend)
      flash[:notice] = "Friendship request cancelled"
    else
      flash[:error] = "No friendship request for #{@friend.profile.full_name || @friend.login}"
    end
    redirect_to hub_url
  end
  
  def delete
    if current_user.friends.include? @friend
      Friendship.breakup(current_user, @friend)
      flash[:notice] = "Friendship with #{@friend.profile.full_name || @friend.login} ended!"
    else
      flash[:error] = "You aren't friends with #{@friend.profile.full_name || @friend.login}"
    end
  end
  
  
  
  private
  
  def setup_friends
    @friend = User.find(params[:id])
  end
end
