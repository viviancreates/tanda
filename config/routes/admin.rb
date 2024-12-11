authenticate :user, ->(user) { user.admin? } do
  mount Blazer::Engine, at: "blazer"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
