require 'action_cable'
require_relative './user'

module ApplicationCable

    class Channel < ActionCable::Channel::Base
    end

    class Connection < ActionCable::Connection::Base
        identified_by :current_user

        def connect
            self.current_user = User.new(cookies[:user_id])
        end

        protected

        def cookies
            @cookies ||= ActionDispatch::Cookies::CookieJar.build(request, request.cookies)
        end
    end
end
