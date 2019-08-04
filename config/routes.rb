Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  devise_for :users

  if Rails.env.development?
    mount GraphqlPlayground::Rails::Engine, at: '/graphql/playground', graphql_path: '/graphql'
  end
end
