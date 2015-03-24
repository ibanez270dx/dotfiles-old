require 'yaml'

GITHUB_USERS_CONFIG_PATH = "#{File.expand_path(File.dirname(__FILE__))}/config.yml"
SSH_CONFIG_PATH = "#{ENV['HOME']}/.ssh/config"

# Get Github User Configuration
@user = YAML.load_file(GITHUB_USERS_CONFIG_PATH)[ARGV[0].to_s]
abort "No key \"#{ARGV[0]}\" found in #{GITHUB_USERS_CONFIG_PATH}." unless @user

# Change Git Config variables
%x( git config --global user.name "#{@user['name']}" )
%x( git config --global user.email "#{@user['email']}" )

# Get SSH Config content and remove any GitHub entries
removal_flag = false
ssh_config = File.open(SSH_CONFIG_PATH, "r").readlines
ssh_config.reject! do |line|
  removal_flag = false if line=~/^Host /
  removal_flag = true  if line=~/^Host github.com/
  removal_flag
end

# Append GitHub entry to SSH Config file
ssh_config += [
  "Host github.com\n",
  "\tUser Git\n",
  "\tIdentityFile #{@user['private_key']}\n",
  "\tIdentitiesOnly yes\n" ]
File.open(SSH_CONFIG_PATH, "w+") do |file|
  file.write ssh_config.join
end

# Add key to SSH agent
%x( ssh-add #{@user['private_key']} )

# Confirm we've switched users
%x( ssh -T git@github.com )
