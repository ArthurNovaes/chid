module Chid
  module Commands
    module Installs
      class Rvm

        def run
          puts "\nInstalling the RVM..."

          ::Chid::on_linux do
            system('sudo apt-add-repository -y ppa:rael-gc/rvm')
            system('sudo apt-get update')
            system('sudo apt-get install curl')
            system('sudo apt-get install rvm')
          end

          ::Chid::on_osx do
            system('\curl -sSL https://get.rvm.io | bash')
          end

          puts "\nRVM installed successfully"
        end

      end
    end
  end
end
