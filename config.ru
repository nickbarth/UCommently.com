#!/usr/bin/env ruby

require 'bundler'
Bundler.require

require 'haml'
require 'sinatra'

class SinatraApp < Sinatra::Base
  configure do
  end

  get '/' do
    'Test'
  end
end

run SinatraApp
