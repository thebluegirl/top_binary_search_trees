class Node
  attr_accessor :left_node, :right_node
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

  protected
  attr_accessor :root
end
