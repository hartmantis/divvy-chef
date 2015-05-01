Divvy Cookbook
==============
[![Cookbook Version](https://img.shields.io/cookbook/v/divvy.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/RoboticCheese/divvy-chef.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/divvy-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/divvy-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/divvy
[travis]: https://travis-ci.org/RoboticCheese/divvy-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/divvy-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/divvy-chef

A Chef cookbook to install Divvy.

Requirements
============

This cookbook currently supports an OS X, App Store-derived installation of
Divvy.

It offers a recipe-based and a resource-based install. Use of the resource
requires that you open a `mac_app_store` resource prior in your Chef run.

Usage
=====

Either add the default recipe to your run_list, or implement the resource in
a recipe of your own.

Recipes
=======

***default***

Installs Divvy (from the Mac App Store or a Windows direct download by
default) and starts it.

Resources
=========

***divvy_app***

Used to perform installation of the app.

Syntax:

    divvy_app 'default' do
        action [:install, :run]
    end

Actions:

| Action     | Description               |
|------------|---------------------------|
| `:install` | Install the app (default) |
| `:run`     | Run the app (default)     |

Attributes:

| Attribute  | Default        | Description          |
|------------|----------------|----------------------|
| action     | `:install`     | Action(s) to perform |

Providers
=========

***Chef::Provider::DivvyApp::MacOsX::AppStore***

Provider for installing Divvy from the Mac App Store (default for OS X).

***Chef::Provider::DivvyApp::MacOsX::Direct***

Provider to do a direct download and install for OS X from the vendor's site. 

***Chef::Provider::DivvyApp::Windows***

Provider to do a direct download and install from the vendor's site (default
for Windows).

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

Copyright 2015 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
