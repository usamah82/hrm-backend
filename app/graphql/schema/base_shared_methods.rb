module Schema
  # Common methods shared by GraphQL base classes
  module BaseSharedMethods
    extend ActiveSupport::Concern

    class_methods do
      # Overrides default graph name generation.
      #
      # - Remove any module prefix string
      # - DO NOT remove "Type" suffix
      def default_graphql_name
        name.split("::").last
      end
    end
  end
end
