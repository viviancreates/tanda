json.extract! task, :id, :user_id, :content, :created_at, :updated_at
json.url task_url(task, format: :json)
