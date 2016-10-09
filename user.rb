# A dummy user class, this'd be normally be an ActiveRecord model or such
class User
    attr_reader :id
    attr_accessor :name
    def initialize(id = rand())
        @id = id
    end
end
