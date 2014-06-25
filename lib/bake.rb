require "bake/version"
require 'thor'
require 'securerandom'

class BakeCLI < Thor

  default_task :bake

  desc 'help', 'Display options'
  def help
    puts """Usage:
  bake init [-n number-of-instances]  # Prepares your app for Bake.
  bake                                # Runs your test suite
"""
  end

  desc 'init', 'Setup curent directory to use bake'
  method_option :instances, aliases: "-n", desc: "Number of instances to setup",
    type: :numeric, default: 5
  def init
    create_bake_repo
    create_herokus(options[:instances])
    git_add_all
    git_push
    puts "You're all ready to bake!"
  end

  desc 'bake', 'Run your test suite in the cloud'
  def bake
    unless File.directory?('.bake')
      not_setup ; return
    end
    puts "Running your test suite in *THE CLOUD*..."
    git_add_all
    git_push
    cucumber
  end

  desc 'cucumber', 'Run cucumber tests'
  def cucumber
    features = Dir['features/**/*.feature']
    slice_length = features.count / instances.count

    threads = features.each_slice(slice_length).to_a.map.with_index do |group, index|
      Thread.new do
        puts `heroku run cucumber -f pretty #{group.join(" ")} --app #{instances[index]}`
      end
    end
    threads.each(&:join)
  end

  private

  def git_push
    puts "Pushing to test instances..."
    threads = instances.map do |name|
      Thread.new do
        system "git --git-dir .bake push -f #{name} master"
        system "heroku ps:scale web=0 --app #{name}"
        prepare_for_tests(name)
      end
    end
    threads.each(&:join)
    puts "Push completed."
  end

  def not_setup
    puts "Your app isn't prepared to bake. Run 'bake init' first."
  end

  def create_bake_repo
    puts "Creating a bake repo..."
    return puts "Bake repo already exists." if File.directory?('.bake')
    system """
      mv .git .gitorig
      git init
      mv .git .bake
      mv .gitorig .git
      echo /.bake >> .gitignore
    """
    puts "Bake repo created."
  end

  def instances
    `git --git-dir .bake remote`.split("\n")
  end

  def prepare_for_tests(name)
    system """
      heroku config:set RAILS_ENV=test RACK_ENV=test --app #{name}
      heroku run rake db:migrate --app #{name}
    """
  end

  def create_herokus(number)
    puts "Creating Heroku test instances..."
    threads = number.times.map do
      Thread.new do
        name = "bake-" + SecureRandom.hex(10)
        system """
          heroku create #{name}
          heroku ps:scale web=0
          heroku config:set BUNDLE_WITHOUT=development --app #{name}
          git --git-dir .bake remote add #{name} git@heroku.com:#{name}.git
        """
      end
    end
    threads.each(&:join)
    puts "Instances created."
  end

  def git_add_all
    system """
      git --git-dir .bake add .
      git --git-dir .bake commit -m 'mmmm...this code smells tasty' >/dev/null
    """
  end

end
