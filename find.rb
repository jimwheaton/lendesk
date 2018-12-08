require 'find'

module Find
  def match(*paths)
    matches = []
    find(*paths) { |path| matches << path if yield path }
    matches
  end
  module_function :match
end