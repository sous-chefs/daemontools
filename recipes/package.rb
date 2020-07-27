#
# Cookbook Name:: daemontools
# Recipe:: package
#
# Author: Joshua Timberman <joshua@chef.io>
#
# Copyright 2010-2012, Opscode, Inc.
# Copyright 2014, Chef Software, Inc. <legal@chef.io>
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

package node['daemontools']['package_name'] do
  # this will be removed in a future major version of the cookbook
  version '0.76-r7' if platform?('gentoo')
end
