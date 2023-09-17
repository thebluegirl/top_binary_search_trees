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
        temp.left_node = replacement.right_node
      end
    end

    return nil if self.find(value).nil?

    if @root.data == value
      if @root.left_node.nil? && @root.right_node.nil?
        @root = nil
        self.pretty_print
        return
      end

      if @root.left_node.nil? && !@root.right_node.nil?
        @root = @root.right_node
        self.pretty_print
        return
      end

      if !@root.left_node.nil? && @root.right_node.nil?
        @root = @root.left_node
        self.pretty_print
        return
      end

      if !@root.left_node.nil? && !@root.right_node.nil?
        case3(@root)
        self.pretty_print
        return
      end
    end

    if value > location.data
      if location.right_node.data == value
        if location.right_node.right_node.nil? && location.right_node.left_node.nil? #delete case 1
          location.right_node = nil
          self.pretty_print
          return
        end

        if !location.right_node.left_node.nil? && location.right_node.right_node.nil? #case 2 with one child node on the left
          location.right_node = location.right_node.left_node
          self.pretty_print
          return
        end

        if location.right_node.left_node.nil? && !location.right_node.right_node.nil? #case 2 with one child node on the right
          location.right_node = location.right_node.right_node
          self.pretty_print
          return
        end

        if !location.right_node.left_node.nil? && !location.right_node.right_node.nil? #delete case 3
          case3(location.right_node)
          self.pretty_print
          return
        end
      end
      delete(value, location.right_node)
    else
      if location.left_node.data == value
        if location.left_node.right_node.nil? && location.left_node.left_node.nil? #delete case 1
          location.left_node = nil
          self.pretty_print
          return 
        end

        if !location.left_node.left_node.nil? && location.left_node.right_node.nil? #case 2 with one child node on the left
          location.left_node = location.left_node.left_node
          self.pretty_print
          return 
        end

        if location.left_node.left_node.nil? && !location.left_node.right_node.nil? #case 2 with one child node on the right
          location.left_node = location.left_node.right_node
          self.pretty_print
          return 
        end

        if !location.left_node.left_node.nil? && !location.left_node.right_node.nil? #delete case 3
          case3(location.left_node)
          self.pretty_print
          return 
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

  protected
  attr_accessor :root
end
