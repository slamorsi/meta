class SlackActivitySerializer < ApplicationSerializer
  attributes :url, :body, :action

  def url
    if object.type == "Activities::Chat"
      chat_room_url(
            ChatRoom.find_by(slug: object.target.slug),
            message: "Hey @#{object.actor.username}!")
    else
      target_entity = object.subject_type == 'Event' ? object.target : object.subject
      url_for(target_entity.url_params)
    end
  end

  def cta_link
    if object.type == "Activities::Chat"
      "<#{url}|Greet me in #{object.target.slug.titleize} chat.>"
    else
      "<#{url}|See what's up.>"
    end
  end

  def body
    if content = object.subject.try(:body)
      content.truncate(160)
    end
  end

  def action
    if object.type == "Activities::Chat"
      "posted my first chat message."
    else
      "created my first #{object.verb}."
    end
  end
end
