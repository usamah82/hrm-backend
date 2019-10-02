# Global attributes to avoid concerns of context passing across layers
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
