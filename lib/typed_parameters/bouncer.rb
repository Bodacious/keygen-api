# frozen_string_literal: true

require_relative 'rule'

module TypedParameters
  class Bouncer < Rule
    def call(params)
      depth_first_map(params) do |param|
        next unless
          param.schema.if? || param.schema.unless?

        cond = param.schema.if? ? param.schema.if : param.schema.unless
        res  = case cond
               in Proc
                 controller.instance_exec(&cond)
               in Symbol
                 controller.send(cond)
               else
                 raise InvalidMethodError, "invalid method: #{cond.inspect}"
               end

        param.delete if
          param.schema.if? ? !res : res
      end
    end
  end
end
