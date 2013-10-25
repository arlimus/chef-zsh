# zsh cookbook

Configure zsh for your system and users. Uses [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) for theme and plugin configuration, if set.

## Requirements

None.

## Attributes
    
    # list of urls of extra themes to add
    ['oh-my-zsh']['themes']    = [ ]

    # hashmap of extra plugin names and urls to add
    ['oh-my-zsh']['plugins']   = { }

## Data Bag fields

## Usage

Just include `chef-zsh` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[chef-zsh]"
  ]
}
```

Add users to your `data_bags`. Example for `data_bags/users/test.json`:

```json
{
  // basic user config
  "id"          : "test",
  "gid"         : "users",
  "home"        : "/home/test",
  // zsh configuration
  "shell"       : "/usr/bin/zsh",
  "zsh_theme"   : "zero-dark",
  "zsh_plugins" : "git extract zero web-search",
}
```

A fully customized example:

```json
{
  "oh-my-zsh": {
    "themes": [
      "https://raw.github.com/arlimus/zero.zsh/master/themes/zero.zsh-theme.base",
      "https://raw.github.com/arlimus/zero.zsh/master/themes/zero-dark.zsh-theme",
      "https://raw.github.com/arlimus/zero.zsh/master/themes/zero-light.zsh-theme"
    ],
    "plugins": {
      "zero": "https://raw.github.com/arlimus/zero.zsh/master/plugins/zero/zero.plugin.zsh"
    }
  },
  "run_list": [
    "recipe[zsh]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: Dominik Richter <dominik.richter@googlemail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
