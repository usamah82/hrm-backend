# Base class for all deriving GraphQL mutation classes
#
class Schema::BaseMutation < GraphQL::Schema::RelayClassicMutation
  # Hook to intercept fields prior to actual resolution
  # In this case, we intercept ActiveModel::Errors and convert them to
  # Types::MutationError instances
  def render_fields(fields)
    fields[:errors] = render_errors(fields[:errors])
    fields
  end

  private
    def render_errors(errors)
      return [] if errors.blank?

      # We only handle ActiveModel::Errors
      return errors unless errors.is_a?(ActiveModel::Errors)

      errors.map do |attribute, message|
        # This is the GraphQL argument which corresponds to the validation error:
        path = ["attributes", attribute.to_s.camelize]
        {
          path: path,
          message: message,
        }
      end
    end
end
