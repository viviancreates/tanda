module MetaTaggable
  extend ActiveSupport::Concern

  def to_meta_tags
    {
      site: "Tanda - Collaborative Savings",
      title: "#{name} - Save Together",
      description: "Join a group to save for a #{name}. Collaborate with friends and family to reach your goal faster.",
      og: {
        title: "#{name} - Save Together",
        description: "Save for #{name} collaboratively with friends and family using Tanda.",
        image: asset_url("favicon.png"), 
      }
    }
  end
end
