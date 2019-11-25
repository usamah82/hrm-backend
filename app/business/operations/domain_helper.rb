module Operations
  # Module to group domain-related concerns e.g namespacing
  module DomainHelper
    # Extracts the absolute, domain-related namespace
    # e.g Operations::Domain::Subdomain::SomeOperation becomes Domain::Subdomain
    def self.to_domain_namespace(operation_class)
      # Remove first and last namespace
      first, *domain_namespace = operation_class.name.deconstantize.split("::")
      domain_namespace.join("::")
    end

    # Extracts operation class name only, without the domain details
    # e.g Operations::Domain::Subdomain::SomeOperation becomes SomeOperation
    def self.to_operation_class_name(operation_class)
      operation_class.name.demodulize
    end
  end
end
