require_relative './bst.rb'
tree = Tree.new(Array.new(15) { rand(1..100) })
puts tree.balanced? ? "This is a balanced binary search tree." : "This binary search tree is not balanced."

puts
puts "Elements listed in level order:"
tree.level_order { |node| print "#{node.data} " }
puts

puts
puts "Elements listed in pre-order:"
tree.preorder { |node| print "#{node.data} " }
puts

puts
puts "Elements listed in post-order:"
tree.postorder { |node| print "#{node.data} " }
puts

puts
puts "Elements listed in order:"
tree.inorder { |node| print "#{node.data} " }
puts

new_values = Array.new(7) { rand(100..1000) }
new_values.each do |num|
  tree.insert(num)
end
puts
puts "New nodes added to tree."
puts tree.balanced? ? "This is still a balanced binary search tree." : "This binary search tree is now unbalanced."

puts
tree.rebalance
puts tree.balanced? ? "This binary search tree has been rebalanced." : "This binary search tree is still unbalanced."

puts
puts "Elements listed in level order:"
tree.level_order { |node| print "#{node.data} " }
puts

puts
puts "Elements listed in pre-order:"
tree.preorder { |node| print "#{node.data} " }
puts

puts
puts "Elements listed in post-order:"
tree.postorder { |node| print "#{node.data} " }
puts

puts
puts "Elements listed in order:"
tree.inorder { |node| print "#{node.data} " }
puts