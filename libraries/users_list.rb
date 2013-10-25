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
      {
        uid:  c['username'] || c['id'],
        gid:  c['gid'] || 'users',
        home: c['home'] || File.join('home',uid)
      }
    end

  end
end