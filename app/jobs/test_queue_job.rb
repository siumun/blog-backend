class TestQueueJob < ApplicationJob
  queue_as :default

  def perform(*args)
	Rails.logger.info "TestQueueJob executed successfully!"
  end
end
