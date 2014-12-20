# encoding: utf-8

module Guard
  class Haml
    class Notifier
      class << self
        def image(result)
          result ? :success : :failed
        end

        def notify(result, message)
          ::Guard::Notifier.notify(message,
                                   title: 'Guard::Haml',
                                   image: image(result)
                                  )
        end
      end
    end
  end
end
