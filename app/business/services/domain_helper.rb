module Services
  # Module to group domain-related concerns e.g namespacing
  module DomainHelper
    # Extracts the absolute, domain-related namespace
    # e.g Services::Domain::Subdomain::CreateSomething becomes Domain::Subdomain
    def self.to_domain_namespace(service_object_class)
      # Remove first and last namespace
      first, *domain_namespace = service_object_class.name.deconstantize.split("::")
      domain_namespace.join("::")
    end

    # Extracts service object class name only, without the domain details
    # e.g Services::Domain::Subdomain::CreateSomething becomes CreateSomething
    def self.to_service_object_class_name(service_object_class)
      service_object_class.name.demodulize
    end
  end
end
