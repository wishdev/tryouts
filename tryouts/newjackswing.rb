
MAIN = self



def run1(*args, &block)
  #DATA.rewind
  a = (DATA.read).split($/)
  a.each_with_index do |line,index|
    code, comment = line.split /\s\#\s/
    puts '%2d> %s' % [index+1, line]
    next if code.nil?
    ret = MAIN.instance_eval "#{code}\n"
    #puts '%2d> %s # => %s' % [index+1, code, ret]
  end
end

class Object
def Object.const_added(*args)
  p args
end
end
HEY = 1
def run(*args, &block)
  a = DATA.read
  p  MAIN.instance_eval a
  p Class.gibbler
end

run

__END__

require 'gibbler'

Class.gibbler                                            # "25ac269ae3ef18cdb4143ad02ca315afb5026de9"

class FullHouse
  include Gibbler::Complex
  attr_accessor :roles
end
a = FullHouse.new
a.roles = [:kimmy, :dj, :joey, :jesse]                  # [:kimmy, :dj, :joey, :jesse] 
a.gibbler                                               # "6ea546919dc4caa2bab69799b71d48810a1b48fa"

