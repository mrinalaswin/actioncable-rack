class ChatChannel < ApplicationCable::Channel
    def subscribed
        stream_from 'messages'
        puts "#{current_user.id} appear"
    end

    def unsubscribed
        puts "#{current_user.id} disappear"
    end

    def appear(data)
        puts "#{current_user.id} appearing on #{data['appearing_on']}"
    end

    def away
        puts "#{current_user.id} went away"
    end

    def set_name(data)
        current_user.name = data['name']
    end

    def send_message(data)
        ActionCable.server.broadcast 'messages',
                                     message: data['message'],
                                     user: current_user.name
    end
end
