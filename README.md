Divvy Cookbook
==============
[![Cookbook Version](https://img.shields.io/cookbook/v/divvy.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/RoboticCheese/divvy-chef.svg)][travis]
[![Windows Build Status](https://img.shields.io/appveyor/ci/RoboticCheese/divvy-chef.svg)][appveyor]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/divvy-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/divvy-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/divvy
[travis]: https://travis-ci.org/RoboticCheese/divvy-chef
[appveyor]: https://ci.appveyor.com/project/RoboticCheese/divvy-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/divvy-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/divvy-chef

A Chef cookbook to install the Divvy desktop manager.

Requirements
============

This cookbook supports all the current platform and distribution methods
offered by the folks behind Divvy (an OS X App Store app and direct site
downloads for both OS X and Windows).

It offers recipe-based and resource-based installs. A resource-based install
from the Mac App Store requires an already-open instance of the `mac_app_store`
resource.

On either supported platform, a user must be signed in for the install to
complete successfully.

Usage
=====

Either add the default recipe to your run_list, or implement the resource in
a recipe of your own.

Recipes
=======

***default***

Installs Divvy (from the Mac App Store or a Windows direct download by
default), sets it to start on login, and starts it up.

Resources
=========

***divvy_app***

Used to perform installation of the app.

Syntax:

    divvy_app 'default' do
      action %i(install enable start)
    end

Actions:

| Action     | Description                      |
|------------|----------------------------------|
| `:install` | Install the app                  |
| `:enable`  | Enable the app to start on login |
| `:start`   | Run the app                      |

Attributes:

| Attribute  | Default                    | Description          |
|------------|----------------------------|----------------------|
| action     | `%i(install enable start)` | Action(s) to perform |

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2015-2016, Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
