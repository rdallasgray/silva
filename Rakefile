#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

$:.unshift File.expand_path("../lib", __FILE__)
require "silva/version"

Rake::TestTask.new do |t|
  t.pattern = 'test/silva/test_*.rb'
end
