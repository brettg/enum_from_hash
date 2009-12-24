# not named test_helper because by default autotest looks for test_*
require 'rubygems'
require 'active_record'
require 'test/spec'
require File.join(File.dirname(__FILE__), '../lib/enum_from_hash.rb')

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :database => ':memory:'
})

ActiveRecord::Schema.define do
  create_table 'boxes' do |t|
    t.integer 'material'
    t.integer 'size_id'
  end
end