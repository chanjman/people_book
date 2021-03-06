# frozen_string_literal: true

class UpdateIndexes < ActiveRecord::Migration[5.1]
  def change
    remove_index :comments, :author_id
    remove_index :comments, %i[commentable_type commentable_id]
    add_index :comments, %i[commentable_type commentable_id author_id], name: :by_commentable_and_author

    remove_index :likes, :user_id
    remove_index :likes, %i[likeable_type likeable_id]
    add_index :likes, %i[likeable_type likeable_id user_id], name: :by_likeable_and_user

    remove_index :notifications, %i[notifiable_type notifiable_id]

    remove_index :photo_albums, :author_id
    add_index :photo_albums, %i[author_id name]

    remove_index :friendships, :user_id
    remove_index :friendships, :friend_id
    add_index :friendships, %i[user_id friend_id], unique: true
  end
end
