# encoding: utf-8

require 'guard/haml'

module Guard
  class Haml < Plugin
    class Notifier
      class << self
        def image(result)
          result ? :success : :failed
        end

        def notify(result, message)
          Compat::UI.notify(message, title: 'Guard::Haml', image: image(result))
        end
      end
    end
  end
end
