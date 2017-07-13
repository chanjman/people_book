class FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[update destroy]

  def index
    @user = User.find(params[:user_id])
    @friends = @user.friends
  end

  def create
    @friendship = current_user.sent_friend_requests.build(friendship_params)
    @friend = @friendship.friend
    if @friendship.save
      flash[:success] = "You sent a friend request to #{@friend.name}"
    else
      flash[:alert] = "We couldn\'t send friend request to #{@friend.name}"
    end
    redirect_to request.referrer || @friend
  end

  def update
    if @friendship.update(accepted: true)
      flash[:success] = "You and #{@friendship.user.name} are now friends"
    else
      flash[:alert] = "We couldn\'t accept friend request from #{@friendship.user.name}"
    end
    redirect_to request.referrer || root_path
  end

  def destroy
    @friend = @friendship.friend
    if @friendship.destroy
      flash[:success] = "You are no longer friends with #{@friend.name}" if @friendship.accepted
    else
      flash[:alert] = "We couldn\'t remove #{@friend.name} as your friend"
    end
    redirect_to request.referrer || @friend
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end
end