
class Tryouts
  
  # = Tryout
  #
  # A Tryout is a set of drills (each drill is a test). 
  #
  class Tryout
  
    # The name of this tryout
  attr_reader :name
    # A default value for Drill.dtype
  attr_reader :dtype
    # A block to executed one time before starting the drills
  attr_reader :setup
    # A block to executed one time before starting the drills
  attr_reader :clean
    # An Array of Drill objects
  attr_reader :drills
    # The number of dreams that came true (successful drills)
  attr_reader :passed
    # The number of dreams that did not come true (failed drills)
  attr_reader :failed
    # The number of skipped drills
  attr_reader :skipped
    # For drill type :cli, this is the name of the command to test. It
    # should be a valid method available to a Rye::Box object.
    # For drill type :api, this attribute is ignored. 
  attr_reader :command
    # A Hash of Dream objects for this Tryout. The keys are drill names. 
  attr_reader :dream_catcher
  
     
  def initialize(name, dtype, command=nil, *args)
    raise "Must supply command for dtype :cli" if dtype == :cli && command.nil?
    raise "#{dtype} is not a valid drill type" if !Drill.valid_dtype?(dtype)
    @name, @dtype, @command = name, dtype, command
    @drills, @dream_catcher = [], []
    @passed, @failed, @skipped = 0, 0, 0
  end
  
  ## ---------------------------------------  EXTERNAL API  -----
  
  # Populate this Tryout from a block. The block should contain calls to 
  # the external DSL methods: dream, drill, xdrill
  def from_block(b=nil, &inline)
    runtime = b.nil? ? inline : b
    begin
      instance_eval &runtime
    rescue => ex
      raise ex
    end
  end
  
  # Execute all Drill objects
  def run
    DrillContext.module_eval &setup if setup.is_a?(Proc)
    puts "\n  %s ".bright % @name unless Tryouts.verbose < 0
    @drills.each do |drill|
      print '   %-70s ' % "\"#{drill.name}\"" unless Tryouts.verbose < 0
      drill.run DrillContext.new
      if drill.skip?
        @skipped += 1
      elsif drill.success?
        @passed += 1
      else
        @failed += 1
      end
      puts drill.flag                           # PASS, FAIL, SKIP
      puts drill.info if Tryouts.verbose > 0 && !drill.skip?  
    end
    DrillContext.module_eval &clean if clean.is_a?(Proc)
  end
  
  # Prints error output. If there are no errors, it prints nothing. 
  def report
    return if Tryouts.verbose < 0
    failed = @drills.select { |d| !d.skip? && !d.success? }
    failed.each_with_index do |drill,index|
      title = ' %-70s %2d/%-2d  ' % ["\"#{drill.name}\"", index+1, failed.size]
      puts $/, ' ' << title.color(:red).att(:reverse)
      puts drill.report
    end
  end
  
  # Did every Tryout finish successfully?
  def success?
    return @success unless @success.nil?
    # Returns true only when every Tryout result returns true
    @success = !(@drills.collect { |r| r.success? }.member?(false))
  end
  
  # Add a Drill object to the list for this Tryout. If there is one or
  # more dreams in +@dream_catcher+, it will be added to drill +d+. 
  def add_drill(d)
    unless @dream_catcher.empty?
      d.add_dreams *@dream_catcher.clone   # We need to clone here b/c
      @dream_catcher.clear                 # Ruby passes by reference.
    end
    drills << d
    d
  end
  
  ## ---------------------------------------  EXTERNAL DSL  -----
  
  # A block to executed one time _before_ starting the drills
  def setup(&block)
    return @setup unless block
    @setup = block
  end
  
  # A block to executed one time _after_ the drills
  def clean(&block)
    return @clean unless block
    @clean = block
  end
  
  # Create and add a Drill object to the list for this Tryout
  # +name+ is the name of the drill. 
  # +args+ is sent directly to the Drill class. The values are specific on the Sergeant.
  def drill(dname, *args, &definition)
    raise "Empty drill name (#{@name})" if dname.nil? || dname.empty?
    drill = Tryouts::Drill.new(dname, @dtype, *args, &definition)
    self.add_drill drill
  end
  # A quick way to comment out a drill
  def xdrill(dname, *args, &b)
    @dream_catcher.clear     # Otherwise the next drill will get them...
    self.add_drill Tryouts::Drill.new(dname, :skip)
  end
  
  
  #
  # NOTE: This method is DSL-only. It's not intended to be used in OO syntax. 
  def dream(*args, &definition) 
    if args.empty?
      dobj = Tryouts::Drill::Dream.from_block definition
    else
      if args.size == 1
        dobj = Tryouts::Drill::Dream.new(args.shift)  # dream 'OUTPUT'
      else
        dobj = Tryouts::Drill::Dream.new(*args)       # dream 'OUTPUT', :format
      end
    end
    @dream_catcher.push dobj
    dobj
  end
  # A quick way to comment out a dream
  def xdream(*args, &b); end
  
end; end