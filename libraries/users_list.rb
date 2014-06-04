#
# Cookbook Name:: chef-zsh
# Library:: users_list
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

class Chef
  class Recipe

    def active_users
      # This segment comes from chef-user cookbook by Fletcher Nichol
      # https://github.com/fnichol/chef-user/blob/master/recipes/data_bag.rb
      # ----------
      bag = node['user']['data_bag_name']

      # Fetch the user array from the node's attribute hash. If a subhash is
      # desired (ex. node['base']['user_accounts']), then set:
      #
      # node['user']['user_array_node_attr'] = "base/user_accounts"
      user_array = node
      node['user']['user_array_node_attr'].split("/").each do |hash_key|
        user_array = user_array.send(:[], hash_key)
      end

      # only manage the subset of users defined
      Array(user_array).map do |i|
        u = data_bag_item(bag, i.gsub(/[.]/, '-'))
      # ----------
        # filter out users who are being removed
        actions = Array(u['action']).map(&:to_sym)
        ( actions.include?(:remove) ) ? nil : u
      # remove all nil entries
      end.compact
      
    end

    # returns an hash with all core fields filled in
    def get_userinfo( c )
      uid = c['username'] || c['id']
      if uid.to_s == "0" || uid == "root"
        {
          uid:  uid,
          gid:  c['gid'] || 'root',
          home: c['home'] || '/root'
        }
      else
        {
          uid:  uid,
          gid:  c['gid'] || 'users',
          home: c['home'] || File.join('home',uid)
        }
      end
    end

  end
end