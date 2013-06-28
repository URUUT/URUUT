class SecondTest
  include Sidekiq::Worker

  def perform(name, count)
    logger.debug "Hello"
  end
  
  def printTest
    Project.print_test
  end
end