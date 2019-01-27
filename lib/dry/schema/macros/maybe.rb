require 'dry/schema/macros/dsl'

module Dry
  module Schema
    module Macros
      # Macro used to specify predicates for a value that can be `nil`
      #
      # @api public
      class Maybe < DSL
        # @api private
        def call(*args, **opts, &block)
          if args.include?(:empty?)
            raise ::Dry::Schema::InvalidSchemaError, "Using maybe with empty? predicate is invalid"
          end

          if args.include?(:none?)
            raise ::Dry::Schema::InvalidSchemaError, "Using maybe with none? predicate is redundant"
          end

          value(*args, **opts, &block)

          self
        end

        # @api private
        def to_ast
          [:implication,
           [
             [:not, [:predicate, [:none?, [[:input, Undefined]]]]],
             trace.to_rule.to_ast
           ]
          ]
        end
      end
    end
  end
end
