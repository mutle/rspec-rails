module Spec

  class HaveHelper < ShouldBase

    def initialize(target, relativity=:exactly, expected=nil)
      @target = target
      @expected = expected == :no ? 0 : expected
      @at_least = (relativity == :at_least)
      @at_most = (relativity == :at_most)
    end
    
    def method_missing(sym, *args)
      fail_with_message(build_message(sym)) unless as_specified?(sym)
    end
    
    def collection(sym)
      @target.send(sym)
    end
    
    def actual_size(collection)
      return collection.length if collection.respond_to? :length
      return collection.size if collection.respond_to? :size
    end
    
    def build_message(sym)
      message = "<#{@target.class.to_s}> should have"
      message += " at least" if @at_least
      message += " at most" if @at_most
      message += " #{@expected} #{sym} (has #{actual_size(collection(sym))})"
    end
    
    def as_specified?(sym)
      return actual_size(collection(sym)) >= @expected if @at_least
      return actual_size(collection(sym)) <= @expected if @at_most
      return actual_size(collection(sym)) == @expected
    end

  end

end