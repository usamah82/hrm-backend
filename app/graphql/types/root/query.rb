module Types
  module Root
    # Registration of query types
    class Query < Schema::BaseObject
      # ---- User ----
      field :me, Types::User, null: true do
        description "Returns the current user"
      end

      # Current user
      def me(demo: false)
        context[:current_user]
      end
    end
  end
end
