God.watch do | w |
  w.name      = "website-update"
  w.interval  = 30.seconds
  w.start     = "ruby /home/andrew/apps/website.update/update.rb"
end