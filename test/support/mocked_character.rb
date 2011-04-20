class MockedCharacter
  attr_accessor :called_actions, :name

  def initialize(name)
    @name, @called_actions = name, Hash.new(0)
  end

  def method_missing(sym, *args, &block)
    @called_actions[sym] += 1
  end

  def respond_to?(sym)
    true
  end

  def action?(scenario = {})
    @scenario = scenario
    @called_actions[:action?] += 1
    :full_attack if @called_actions[:action?] > 1
  end

  def dead?
    false
  end
end
