module ExceptionNotifier
  class SlackNotifier

    attr_accessor :notifier

    def initialize(options)
      begin
        webhook_url = options.fetch(:webhook_url)
        @message_opts = options.fetch(:additional_parameters, {})
        @full_stack = options.fetch(:include_stacktrace, nil)
        @notifier = Slack::Notifier.new webhook_url, options
      rescue
        @notifier = nil
      end
    end

    def call(exception, options={})
      stack = @full_stack.nil? ? exception.backtrace.first : exception.backtrace.join('') 
      message = "An exception occurred: '#{exception.message}' on '#{stack}'"
      @notifier.ping(message, @message_opts) if valid?
    end

    protected

    def valid?
      !@notifier.nil?
    end
  end
end
