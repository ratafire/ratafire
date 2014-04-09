if %x[ps axo command|grep resque[-]|grep -c Forked].to_i > 0 
  raise "Resque Workers Working!!" 
else 
  run "sudo monit stop all -g fractalresque_resque" 
end 