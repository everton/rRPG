#-*- coding: utf-8 -*-

begin
  require 'bundler'
  Bundler.setup
  Bundler.require(:default, :test)
rescue LoadError => e
  puts "\nBundler is not available:\t#{e}"
end

begin
  require 'simplecov'
  SimpleCov.start do
    add_filter "/test/"
    add_filter "/vendor/"
    add_group "Support", "/support"
    add_group "Character Modules", "/character/modules"
  end
rescue LoadError => e
  puts "\nCoverage is not available:\t#{e}"
end
