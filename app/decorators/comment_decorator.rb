# frozen_string_literal: true

class CommentDecorator < ApplicationDecorator
    delegate_all
    decorates_association :user
  
    def for?(commentable)
      commentable = commentable.object if commentable.decorated?
  
      commentable == self.commentable
    end

    def formatted_created_at
      l created_at, format: :long
    end
end