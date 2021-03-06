class Board
  attr_accessor :x, :y

  def initialize
    @board = []
    @size = 10

    @size.times do |c|
      @size.times do |r|
        @board[c] ||= []
        @board[c][r] = '.'
      end
    end
  end

  def print
    @board.each do |row|
      puts row.join(' ')
    end
  end

  def sample
    @board.each do |row|
      row.each_with_index do |item, index|
        row[index] = ['#','.'].sample
      end
    end   
  end

  def variants(item)
    acc = []
    10000.times do
      generation = Array.new(@size) {|index| rand(0..1)}
      data = generation.join.split('0').map{|x|x.length} - [0]
      acc << generation if item == data
    end
    acc.uniq
  end

  def draw(line)
    line.map{|c|c == 1 ? '# ' : '. '}.join
  end

  def shift(counter)
    counter.reverse.each_with_index do |r, index|
      if r != 9
        counter[counter.length-1] = 0
        counter[counter.length-index-1] = r + 1
        break
      else
        counter[counter.length-index-1] = 0
      end
    end
    @counter = counter
  end

  def increment
    @counter = [0,0,0,0,0,0,0,0,0,0,0]

    (1..250).each do
      current = @counter.last

      if current != 9
        @counter[@counter.length-1] = current + 1
      else
        shift(@counter)
      end

      #@counter[@counter.length-1] = 0
      #c2 = @counter[@counter.length-2]
      #@counter[@counter.length-2] = c2 + 1
      puts @counter.inspect
    end


    #@counter.last = @counter.last + 1
  end

  def assemble(total)
    counts = total.map {|_, value| value.count - 1}
    #abort counts.inject(&:*).inspect
    
    #counts.each do |row|
      increment
    #end

    abort 1.inspect

    set = []
    collection = {}

    @size.times do |a|
      pick = nil
      @size.times do |b|
        pick = total[a][b]
        if pick
          collection[b] = pick
        else
          next
        end
      end
      set << collection
    end

    set.each do |solution|
      if y == extract_y(solution)
        abort 'Got It'.inspect
        #puts y.inspect
        #puts extract_y(solution).inspect
        #return solution
      end
    end
  end

  def extract_y(solution)
    xs = []
    solution.values.transpose.each do |column|
      xs << column.join.split('0').map{|x|x.length} - [0]
    end
    xs
  end

  def brute
    total = {}
    x.each_with_index do |item, index|
      v = variants(item)
      v.each do |line|
        total[index] ||= []
        total[index] << line
      end
    end

    assemble(total).each do |picture|
      picture.each do |_,line|
        puts draw(line)
      end
      puts "=================".inspect
    end
  end
end

trap("INT") do
  File.write('iteration', rand(1..100))
  exit
end

b = Board.new
b.x = [[3],[1,1],[1,1,1],[2,1],[1,5],[1,1,1],[1,3,1],[2,2],[7],[1,1]]
b.y = [[1],[7],[1,2],[1,1,1],[1,2],[4,1,1],[1,1,2],[3,1],[1,2],[4]]
b.brute


#b.demo
#b.sample
#b.solve

b.print
