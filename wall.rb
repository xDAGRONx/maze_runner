class Wall < Node
  def paint
    path? ? super : Paint['  ', nil, 46]
  end
end
