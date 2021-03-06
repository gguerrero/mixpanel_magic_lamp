module MixpanelMagicLamp

  module ClassMethods
    def where(*args)
      MixpanelMagicLamp::InstanceMethods::ExpressionBuilder.new(*args)
    end

    def on(property)
      "properties[\"#{property}\"]"
    end
  end

  module InstanceMethods
    class ExpressionBuilder
      attr_reader :expression

      def initialize(*args)
        @expression = ''
        equals(*args) if args.any?
      end

      def to_s
        @expression
      end

      def and
        @expression += ' and ' if @expression.present? and not @expression =~ /(and|or)\s*$/
        self
      end

      def or
        @expression += ' or ' if @expression.present? and not @expression =~ /(and|or)\s*$/
        self
      end

      def equals(args = {}, union = 'and')
        @expression += join(args, union, "properties[\":name\"] == \":value\"")
        self
      end

      def does_not_equal(args = {}, union = 'and')
        @expression += join(args, union, "properties[\":name\"] != \":value\"")
        self
      end

      def contains(args = {}, union = 'and')
        @expression += join(args, union, "\":value\" in (properties[\":name\"])")
        self
      end

      def does_not_contain(args = {}, union = 'and')
        @expression += join(args, union, "not \":value\" in (properties[\":name\"])")
        self
      end

      def is_set(args = [], union = 'and')
        @expression += join(args, union, "defined (properties[\":name\"])")
        self
      end

      def is_not_set(args = [], union = 'and')
        @expression += join(args, union, "not defined (properties[\":name\"])")
        self
      end

      private
      def join(args, union, exp)
        args = [args] unless args.is_a? Array or args.is_a? Hash
        (args.is_a? Array) ? args.compact! : args.reject! {|k,v| v.nil?}

        built_in = '(' + args.map do |name, values|
          if values.nil?
            exp.gsub(':name', name)
          else
            values = [values] unless values.is_a? Array
            values.map do |value|
              exp.gsub(':name', name.to_s).gsub(':value', value.to_s)
            end
          end
        end.flatten.join(" #{union} ") + ')'

        built_in == '()' ? '' : built_in
      end
    end
  end

end
