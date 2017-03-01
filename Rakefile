require_relative 'main'
require_relative 'news_api'
require_relative 'currency_api'

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end

task :default => :chid

desc 'Open all Applications for workstation'
task :workstation do
  system('open -a "safari"')
  system('open -a "telegram desktop"')
  system('open -a "slack"')
  system('open -a "android studio"')
  system('open -a "xcode"')
  system('open -a "spotify"')
  system('open -a "messages"')
  system('open -a "tomato one"')
  system('open -a "zonebox"')
end

desc 'Convert USD to BRL'
task :convert do
  currency = CurrencyApi.convert(amount: 10)
  puts "The amount converted to BRL is: #{currency}"
end

desc 'Get the currency conversion for USD to BRL'
task :currency do
  currency = CurrencyApi.convert()
  puts "USD is #{currency} BRL"
end

desc 'List all news'
task :news do
  articles = NewsApi.articles

  #articles.select { |a| /ruby/.match(a.title) }
  articles.each do |a|
    published_at = a.publishedAt.nil? ? 'unkown' : a.publishedAt.strftime("%B %d, %Y")
    print "\n"
    print "--- #{a.title} ---".blue
    print "\n"
    print "  Posted #{published_at} by ".brown
    print "#{a.author}".green
    print "\n\n"
    print "  #{a.description}"
    print "\n\n"
    print "  Link: "
    print "#{a.url}".cyan.underline
    print "\n"
  end

  puts "\n#{NewsApi.current_page} of #{NewsApi.total_pages}"

  if NewsApi.total_pages > 1
    puts "\nPrevious(p) Next(n) Quit(q):"
    print "> "
    option = STDIN.gets
    if (/^q/.match(option))
        NewsApi.reset
      end

      if (/^n/.match(option))
        NewsApi.increase_page_by_1
        Rake::Task['news'].execute
      end

      if (/^p/.match(option))
        NewsApi.deacrease_page_by_1
        Rake::Task['news'].execute
      end
  end
end

desc 'Init the initial config for Chid app'
task :init do
  print  "Configurating the Chid app...\n\n"
  chid_path = Dir.pwd
  username = %x[echo $(logname)]
  path = "/Users/#{username.strip}/"

  print "Appending the chid alias on your "
  print ".bashrc\n\n".blue
  File.open(File.join(path, '.bashrc'), 'a') do |f|
  #  f.write "\nalias chid='rake -f #{chid_path}/Rakefile'"
  end

  print "Configuration done!\n\n"

  print "Chid is an assistant to help your day-to-day life. It can be used in some installations, news, etc.\n\n"
  print "You can use it without starting the app through Rake Tasks or as an app, having a greater interaction with it.\n\n"

  print "To initialize the app you can run the command: "
  print "$ rake\n".blue
  print "Or the command: "
  print "$ chid\n".blue
  print "But for the "
  print "$ chid ".blue
  print "command works you must reload your .bashrc\n\n"

  print "To reload your .bashrc you can run: "
  print "source #{path}.bashrc".blue

  print "\n\nInitializing the chid app..\n\n"
  Rake::Task['chid'].execute
end

desc 'Init the Chid app'
task :chid do
  #ruby 'main.rb'
  #Main.init
  sh 'echo Hello $(logname)', verbose: false
  puts "\nHow can I help you?"

  loop do
    print "> "
    line = STDIN.gets
    if line =~ /^:q/ || line =~ /^bye/ || line =~ /^quit/
      puts "Bye Bye"
      break
    end
    action = Main.init(line)

    #puts "Choose action: #{action}"

    if (action == :news)
      Rake::Task['news'].execute
      puts "\nDone! Something else?"
    end

    if (action == :currency)
      Rake::Task['currency'].execute
      puts "\nDone! Something else?"
    end

    if (action == :convert)
      Rake::Task['convert'].execute
      puts "\nDone! Something else?"
    end

    if (action == :rvm)
      Rake::Task['install:rvm'].execute
      puts "\nRVM installed! Something else?"
    end

    if (action == :postgres)
      Rake::Task['install:postgres'].execute
      puts "\nPostgres installed! Something else?"
    end

    if (action == :node)
      Rake::Task['install:node'].execute
      puts "\nNode installed! Something else?"
    end

    if (action == :dotfiles)
      Rake::Task['install:dotfiles'].execute
      puts "\nDotfiles installed! Something else?"
    end

    if (action == :workstation)
      Rake::Task['workstation'].execute
      puts "\nEverything opened! Something else?"
    end

    if (action == :help)
      puts "I can help you with:"
      puts "  - news        -> List all news on web"
      puts "  - currency    -> Show the current currency for USD to BRL"
      puts "  - convert     -> Convert some amount from USD to BRL"
      puts "  - rvm         -> Installing the RVM"
      puts "  - postgres    -> Installing and Run the Postgres"
      puts "  - node        -> Installing the Node"
      puts "  - dotfiles    -> Installing the YARD Dotfiles"
      puts "  - workstation -> Open all application you use every day"
      puts "\nTell me what you need"
    end

  end

end

desc 'Configure default windows for development'
task :tmux_config do
  system("tmux rename-window bash")
  system("tmux new-window -n app")
  system("tmux new-window -n server")
end

desc 'Open or Create the new session for development key'
task :tmux do
  session = system('tmux attach -t development')
  unless session
    system('tmux new -s development')
  end
end

namespace :run do
  desc 'Start Postgres for OSx'
  task :postgres do
    system('postgres -D /usr/local/var/postgres')
  end

end

namespace :install do

  desc 'Install RVM'
  task :rvm do
    system('\curl -sSL https://get.rvm.io | bash')
  end

  desc 'Install Postgres'
  task :postgres do
     platform = %x[echo $OSTYPE]

     if  platform =~ /linux/
       system('sudo apt-get install postgresql postgresql-contrib')
     end

     if  platform =~ /darwin/
       system('brew install postgres')
     end
  end

  desc 'Install Node'
  task :node do
    platform = %x[echo $OSTYPE]

     if  platform =~ /linux/
       system('sudo apt-get install nodejs')
     end

     if  platform =~ /darwin/
       system('brew install node')
     end
  end

  desc 'Install YADR Dotfiles'
  task :dotfiles do
    system('sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"')

    puts 'Updating...'
    username = %x[echo $(logname)]
    path = "/Users/#{username.strip}/.yadr/"
    Dir.chdir path
    system('git pull --rebase')
    system('rake update')
  end
end
