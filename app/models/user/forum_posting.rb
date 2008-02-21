class User
  # Creates new topic and post.
  # Only..
  #  - sets sticky/locked bits if you're a moderator or admin 
  #  - changes forum_id if you're an admin
  #
  def post_to_forum(forum, attributes)
    attributes.symbolize_keys!
    Topic.new(attributes) do |topic|
      topic.forum = forum
      topic.user  = self
      revise topic, attributes
    end
  end

  def reply_to_forum_topic(topic, body)
    returning topic.posts.build(:body => body) do |post|
      post.forum = topic.forum
      post.user  = self
      post.save
    end
  end
  
  def revise(topic, attributes)
    case record
      when Topic then revise_topic(record, attributes)
      when Post  then post.save
      else raise "Invalid record to revise: #{record.class.name.inspect}"
    end
    record
  end
  
protected

  def revise_topic(topic, attributes)
    topic.sticky, topic.locked = attributes[:sticky], attributes[:locked] if moderator_of?(topic.forum)
    topic.save
  end
end