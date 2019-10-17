module Services
  # Default form object concerns for service objects
  class DefaultServiceFormObject
    # Return the form object class (input class) for a give service object class
    #
    # e.g Services::User::CreateUser would map to to FormObjects::User::CreateUser
    #
    # Returns the class name if no such class can be constantized.
    def self.form_object_class(service_object_class)
      domain_namespace = DomainHelper.to_domain_namespace(service_object_class)
      service_object_class_name = DomainHelper.to_service_object_class_name(service_object_class)

      form_object_class_name = "FormObjects::" + domain_namespace + "::" + service_object_class_name

      form_object =
        begin
          form_object_class_name.constantize
        rescue
          form_object_class_name
        end

      form_object
    end
  end
end
