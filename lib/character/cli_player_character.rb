#-*- coding: utf-8 -*-

class CLIPlayerCharacter < PlayerCharacter
  def action(scenario)
    print "\e[H \e[2J"

    others = scenario[:characters].select {|c| c != self }
    lines, cols = scenario[:br]
    print ' ' * 2
    0.upto(cols) { |col| print "%02d " % col }

    puts
    0.upto(lines) do |line|
      print "%02d " % line

      0.upto(cols) do |col|
        c = '  '
        others.each do |e|
          c = "#{e.dead? ? '+' : 'e'} " if e.x == col and e.y == line
        end

        c += ((@x == col and @y == line) ? '*' : ' ')
        print c
      end
      puts
    end

    puts
    puts "#{self.name}: ht => #{self.ht} x,y => (#{self.x} #{self.y})"
    others.each do |e|
      puts "#{e.name}:  ht => #{e.ht} x,y => (#{e.x} #{e.y}) dist: #{distance_of(e.x, e.y)}"
    end
    puts
    print "Actions: quit, move, full_attack, move_and_attack: "
    STDIN.readline.strip.to_sym
  end

  def move(scenario)
    x, y = where_to_go?(scenario)
    goto(x, y, full_displacement)
  end

  def full_attack(scenario)
    e = who_to_attack(scenario)
    return if distance_of(e.x, e.y) > √(2) # is not neighbor

    e.ht -= full_damage if attack_success?
  end

  def move_and_attack(scenario)
    x, y = where_to_go?(scenario)
    goto(x, y, reduced_displacement)

    e = who_to_attack(scenario)
    return if distance_of(e.x, e.y) > √(2) # is not neighbor

    e.ht -= reduced_damage if attack_success?
  end

  private
  def where_to_go?(scenario)
    print "Move to? (x, y): "
    match = STDIN.readline.strip.match(/(\d+)[^\d]+(\d+)/)
    return where_to_go?(scenario) unless match

    match.captures.collect &:to_i
  end

  def who_to_attack(scenario)
    others = scenario[:characters]
      .reject{|c| c == self or c.dead? }

    return others.first if others.size == 1

    print "Attack Who? #{others.collect &:name}: "
    name = STDIN.readline.strip

    enemy = others.select{|e| e.name == name }.first
    return who_to_attack(scenario) unless enemy
    enemy
  end
end
