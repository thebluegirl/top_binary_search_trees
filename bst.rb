class Node
  attr_accessor :left_node, :right_node, :data
  include Comparable
  attr :data
  def <=>(other_node)
    data <=> other_node.data
  end

  def initialize(data, left_node=nil, right_node=nil)
    @data = data
    @left_node = left_node
    @right_node = right_node
  end
end

class Tree
  attr_reader :root
  def initialize(arr)
    @arr = arr.to_a.sort.uniq
    @root = build_tree(@arr, 0, @arr.size - 1)
    @queue = Array.new
  end

  def build_tree(arr, arr_start, arr_end)
    return nil if arr_start > arr_end
    middle = (arr_start + arr_end) / 2
    node = Node.new(arr[middle])
    node.left_node = build_tree(arr, arr_start, middle - 1)
    node.right_node = build_tree(arr, middle + 1, arr_end)
    return node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
  end

  def insert(value, location=@root)
    return @root = Node.new(value) if @root.nil?
    
    if location.data > value
      return location.left_node = Node.new(value) if location.left_node.nil?
      insert(value, location.left_node)
    else
      return location.right_node = Node.new(value) if location.right_node.nil?
      insert(value, location.right_node)
    end
  end

  def delete(value, location=@root)
    return nil if self.find(value).nil?
    def case3(node)
      temp = node.right_node
      replacement = temp
      if !temp.left_node.nil?
        until temp.left_node.left_node.nil?
          temp = temp.left_node
        end
        replacement = temp.left_node
      end
      
      if node == @root #if the node to be deleted is the root of the tree
        @root = Node.new(replacement.data, node.left_node, node.right_node)
      else
        node.data = replacement.data
      end
      
      if temp == replacement #the replacement of the node is its right node
        return node.right_node = replacement.right_node
      end

      if replacement.left_node.nil? && replacement.right_node.nil? #delete case 1
        return temp.left_node = nil
      elsif replacement.left_node.nil? && !replacement.right_node.nil? #delete case 2
        return temp.left_node = replacement.right_node
      end
    end

    if @root.data == value
      if @root.left_node.nil? && @root.right_node.nil?
        return @root = nil
      end

      if @root.left_node.nil? && !@root.right_node.nil?
        return @root = @root.right_node
      end

      if !@root.left_node.nil? && @root.right_node.nil?
        return @root = @root.left_node
      end

      if !@root.left_node.nil? && !@root.right_node.nil?
        return case3(@root)
      end
    end

    if value > location.data
      if location.right_node.data == value
        if location.right_node.right_node.nil? && location.right_node.left_node.nil? #delete case 1
         return location.right_node = nil
        end

        if !location.right_node.left_node.nil? && location.right_node.right_node.nil? #case 2 with one child node on the left
          return location.right_node = location.right_node.left_node
        end

        if location.right_node.left_node.nil? && !location.right_node.right_node.nil? #case 2 with one child node on the right
          return location.right_node = location.right_node.right_node
        end

        if !location.right_node.left_node.nil? && !location.right_node.right_node.nil? #delete case 3
          return case3(location.right_node)
        end
      end
      delete(value, location.right_node)
    else
      if location.left_node.data == value
        if location.left_node.right_node.nil? && location.left_node.left_node.nil? #delete case 1
          return location.left_node = nil
        end

        if !location.left_node.left_node.nil? && location.left_node.right_node.nil? #case 2 with one child node on the left
          return location.left_node = location.left_node.left_node
        end

        if location.left_node.left_node.nil? && !location.left_node.right_node.nil? #case 2 with one child node on the right
          return location.left_node = location.left_node.right_node
        end

        if !location.left_node.left_node.nil? && !location.left_node.right_node.nil? #delete case 3
          return case3(location.left_node)
        end
      end
      delete(value, location.left_node)
    end
  end

  def find(value, location=@root)
    return nil if location.nil?
    if location.data == value
      return location
    elsif location.data > value
      find(value, location.left_node)
    else
      find(value, location.right_node)
    end
  end

  def level_order
    @queue = Array.new
    def enqueue(node)
      return if node.nil?
      @queue << node unless @queue.any?(node)
      unless node.left_node.nil? && node.right_node.nil?
        @queue << node.left_node unless node.left_node.nil?
        @queue << node.right_node unless node.right_node.nil?
      end
    end

    dequeue = lambda do
      yield(@queue[0])
      @queue.shift
      enqueue(@queue[0])
    end

    enqueue(@root)
    if block_given?
      until @queue.empty?
        dequeue.call
      end
      return
    end
    counter = 1
    until counter == @queue.length - 1
      enqueue(@queue[counter])
      counter += 1
    end
    return @queue
  end

  def preorder
    @queue = Array.new
    dequeue = lambda do
      if block_given?
        yield @queue[0]
        @queue.shift
      end
    end
    
    def enqueue(node, block)
      return if node.nil?
      @queue << node
      block.call
      enqueue(node.left_node, block)
      enqueue(node.right_node, block)
    end

    enqueue(@root, dequeue)
    return @queue if !block_given?
  end

  protected
  attr_accessor :root, :queue
end
