  desc 'Compile .rb file from Qt Designer Form (.ui)'
  task(:build) do
    Dir['*.ui'].each do |i|
      system("rbuic4 -x #{i} -o #{File.basename(i, '.ui')}_ui.rb")
      puts "#{i} -> #{File.basename(i, '.ui')}_ui.rb"
    end
  end

  desc 'Launch application from start.rb'
  task (:launch) => :build  do
    puts 'Launching...'
    system('ruby start.rb')
  end
  
  task (:default) => :launch do end