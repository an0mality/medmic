class RhbType < MseConnection
  RhbType.table_name = "rhb_type"
  has_one :prg_rhb
end
