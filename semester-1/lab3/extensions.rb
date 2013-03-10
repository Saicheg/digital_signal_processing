class Array

  def to_dots(values)
    values.each_with_index.map{|val, i| OpenStruct.new({x: val, y: self[i]})}
  end

end
