#-*- coding: utf-8 -*-

class CLIPlayerCharacter < PlayerCharacter
  def action?(scenario)
    print "\e[H \e[2J"

    others = scenario[:others]
    lines, cols = scenario[:br]
    print ' ' * 2
    0.upto(cols) { |col| print "%02d " % col }

    puts
    0.upto(lines) do |line|
      print "%02d " % line

      0.upto(cols) do |col|
        c = '  '
        others.each do |e|
          c = 'e ' if e.x == col and e.y == line
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
    puts "Actions: quit, move, full_attack, move_and_attack\n"
    STDIN.readline.strip.to_sym
  end

  def move(scenario)
    x, y = where_to_go?(scenario)
    goto(x, y, full_displacement)
  end

  def full_attack(scenario)
    enemy = who_to_attack(scenario)
    success = attack_success?
    enemy.ht -= full_damage if success
    puts "Success? #{success} Enemy.ht: #{enemy.ht}"
  end

  def dead?
    dead = @ht < 1
    puts "+++++" if dead
    dead
  end

  def move_and_attack(scenario)
    x, y = where_to_go?(scenario)
    goto(x, y, reduced_displacement)

    enemy = who_to_attack(scenario)
    success = attack_success?
    enemy.ht -= reduced_damage if success

    puts "Success? #{success} Enemy.ht: #{enemy.ht}"
  end

  private
  def where_to_go?(scenario)
    print "Move to? (x, y): "
    match = STDIN.readline.strip.match(/(\d+)[^\d]+(\d+)/)
    return where_to_go?(scenario) unless match

    match.captures.collect &:to_i
  end

  def who_to_attack(scenario)
    others = scenario[:others]
    print "Attack Who? #{others.collect &:name}: "
    name = STDIN.readline.strip

    enemy = others.select{|e| e.name == name }.first
    return who_to_attack(scenario) unless enemy
    enemy
  end
end
