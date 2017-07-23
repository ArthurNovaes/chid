module Chid
  class Command

    class << self
      attr_accessor :summary, :description, :arguments

      COMMANDS = {
        init: 'Chid::Commands::Init'
      }

      def help
        <<-DOC
        #{summary}

        #{description}

        #{arguments}
        DOC
      end

      def run(argv)
        return self.help unless command_key_is_included?(argv)
        invoke(argv)
      end

      # Returns a mapped options with your values from @argv
      #
      # @param [Array<String>] argv
      #        The arguments passed from input.
      #
      # @return [Hash<String, Array>] Mapped options with your values
      #         The keys of hash are the options and the values of hash
      #         are all values for the option.
      #
      # @example Map an argv
      #   argv = ['init', '-option_1', 'value_for_option_1']
      #
      #   map_options_with_values(argv) #=> {'-option1' => ['value_for_option_1']}
      #
      def map_options_with_values(argv)
        return argv.reduce({}) do |options, arg|
          new_options = options

          if arg_is_an_option?(arg)
            new_options[arg] = []
            next(new_options)
          end

         options_with_values(new_options, arg)
        end
      end

      private

      def arg_is_an_option?(arg)
        arg.include?('-')
      end

      def options_with_values(options, arg)
        new_options = options
        last_option = new_options.keys.last
        new_options[last_option] << arg if last_option

        new_options
      end

      def command_key_is_included?(argv)
        COMMANDS.include?(command_key(argv))
      end

      def command_key(argv)
        argv[0].to_sym
      end

      # Convenience method.
      # Instantiate the command and run it with the provided arguments at once.
      #
      # @param [String..., Array<String>] args
      #        The arguments to initialize the command with
      #
      def invoke(argv)
        command = new_command_instance(command_key(argv), map_options_with_values(argv))
        return command.class.help unless has_valid_arguments?(command.class, argv)
        command.run
      end

      def new_command_instance(command_key, options)
        Object.const_get(COMMANDS[command_key]).new(options)
      end

      def has_valid_arguments?(command_class, argv)
        options = map_options_with_values(argv)

        command_class.arguments.include?(options.keys)
      end

    end

    # --- Instance methods ---

    public

    def initialize(argv)
      options = self.class.map_options_with_values(argv)
    end

  end
end
