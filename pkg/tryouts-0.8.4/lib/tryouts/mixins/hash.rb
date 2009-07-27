
class Hash
  
  # A depth-first look to find the deepest point in the Hash. 
  # The top level Hash is counted in the total so the final
  # number is the depth of its children + 1. An example:
  # 
  #     ahash = { :level1 => { :level2 => {} } }
  #     ahash.deepest_point  # => 3
  #
  def deepest_point(h=self, steps=0)
    if h.is_a?(Hash)
      steps += 1
      h.each_pair do |n,possible_h|
        ret = deepest_point(possible_h, steps)
        steps = ret if steps < ret
      end
    else
      return 0
    end
    steps
  end
  
  unless method_defined?(:last)
    # Ruby 1.9 doesn't have a Hash#last (but Tryouts::OrderedHash does). 
    # It's used in Tryouts to return the most recently added instance of
    # Tryouts to @@instances. 
    #
    # NOTE: This method is defined only when Hash.method_defined?(:last)
    # returns false. 
    def last
      self[ self.keys.last ]
    end
  end
  
end

