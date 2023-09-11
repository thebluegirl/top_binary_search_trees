class Node
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
  def initialize(arr)
    @arr = arr.to_a.uniq
  end
end