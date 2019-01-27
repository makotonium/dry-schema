require 'dry/schema/macros/dsl'

module Dry
  module Schema
    module Macros
      # A macro used for specifying predicates to be applied to values from a hash
      #
      # @api public
      class Value < DSL
        # @api private
        def call(*predicates, **opts, &block)
          trace.evaluate(*predicates, **opts, &block)

          trace.append(new(chain: false).instance_exec(&block)) if block

          if trace.captures.empty?
            raise ArgumentError, 'wrong number of arguments (given 0, expected at least 1)'
          end

          self
        end

        # @api private
        def respond_to_missing?(meth, include_private = false)
          super || meth.to_s.end_with?(QUESTION_MARK)
        end

        private

        # @api private
        def method_missing(meth, *args, &block)
          if meth.to_s.end_with?(QUESTION_MARK)
            trace.__send__(meth, *args, &block)
          else
            super
          end
        end
      end
    end
  end
end
