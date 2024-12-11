authenticate :user, ->(user) { user.admin? } do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
