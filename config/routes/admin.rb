authenticate :user, ->(user) { user.admin? } do
  mount Blazer::Engine, at: "blazer"
  mount GoodJob::Engine => "good_job"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
