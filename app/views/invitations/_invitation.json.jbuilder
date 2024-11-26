json.extract! invitation, :id, :sender_id, :receiver_id, :tanda_id, :status, :created_at, :updated_at
json.url invitation_url(invitation, format: :json)
