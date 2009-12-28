God.watch do | w |
  w.name      = "website-update"
  w.interval  = 30.seconds
  w.start     = "ruby /home/andrew/apps/website.update/service.rb"

	w.uid				= "andrew"
  
  w.behavior(:clean_pid_file) 
  
  # Checks if process is running every 5 seconds 
  w.start_if do |start| 
    start.condition(:process_running) do |c| 
      c.interval = 5.seconds 
      c.running = false 
    end 
  end
  
end