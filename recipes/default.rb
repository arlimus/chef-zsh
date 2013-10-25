#
# Cookbook Name:: chef-zsh
# Recipe:: default
#
# Copyright 2013, Dominik Richter
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install and configure zsh
# * oh-my-zsh
# * zshrc
# * per-user configuration, depending on databags

def get_userinfo c
  [
    c['id'],
    c['gid'] || 'users',
    c['home'] || File.join('home',uid)
  ]
end

# install zsh
package "zsh"

# add configuration for all users
search("users","default_shell:/usr/bin/zsh").each do |c|
  Chef::Log.info "gitconfig: setting shell to zsh foruser #{c['id']}"
  
  # presets
  uid, gid, home = get_userinfo c
  omz_home = File.join home, '.oh-my-zsh'
  omz_themes = File.join omz_home, 'themes'
  omz_plugins = File.join omz_home, 'plugins'
  enable_omz = (
    not node['oh-my-zsh']['themes'].empty? or
    not node['oh-my-zsh']['plugins'].empty? or
    not c['zsh_theme'].nil? or
    not c['zsh_plugins'].nil?
    )

  # install oh-my-zsh if necessary
  if enable_omz
    # we need to get oh-my-zsh from git
    package "git-core"
    # clone the git repo
    execute "git clone https://github.com/robbyrussell/oh-my-zsh.git #{omz_home}" do
      not_if { ::File.exists? omz_home}
    end
    # adjust the directory's permissions to allow user modifications
    directory omz_home do
      owner uid
      group gid
    end
  end

  # add a few custom themes
  node['oh-my-zsh']['themes'].each do |url|
    # download the theme file
    remote_file File.join( omz_themes, File.basename(url) ) do
      source url
      mode 00644
    end
  end

  # download custom plugins
  node['oh-my-zsh']['plugins'].each do |plugin,url|
    # create a folder for the plugin
    path = File.join omz_plugins, plugin
    directory path do
      owner uid
      group gid
    end
    # download the plugin file
    remote_file File.join( path, File.basename(url) ) do
      source url
      mode 00644
    end
  end

  # set up the .zshrc
  zshrc_home = File.join home, '.zshrc'
  template zshrc_home do
    source "zshrc.erb"
    mode 0644
    owner uid
    group gid
    variables({
      :enable_omz => enable_omz,
      :theme => c['zsh_theme'] || 'robbyrussell',
      :plugins => c['zsh_plugins'] || ''
    })
  end
end
