class KeepAliveJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url = "https://tanda-9o52.onrender.com"
    response = HTTP.timeout(60).get(url)

    if response.status.success?
      Rails.logger.info("Successfully pinged #{url}")
      response.status
    else
      Rails.logger.warning("Unable to ping #{url}, received status#{response.status}")
      response.status
    end
  end
end
