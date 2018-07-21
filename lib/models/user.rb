class User < Struct.new(:id)
  def find(*)
    raise NotImplementedError
  end
end
