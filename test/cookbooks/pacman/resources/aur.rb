# frozen_string_literal: true

provides :pacman_aur
unified_mode true

property :package_name, String, name_property: true
property :patches, [String, Array],
         coerce: proc { |value| Array(value) },
         default: []
property :pkgbuild_src, [true, false], default: false

default_action %i(build install)

action :build do
end

action :install do
end
