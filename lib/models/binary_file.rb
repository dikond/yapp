class BinaryFile < Sequel::Model(:binary_files)
  many_to_one :analysis
end
