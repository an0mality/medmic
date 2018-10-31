class RhbExc < MseConnection
  RhbExc.table_name = "rhb_exc"
  has_one :prg_rhb
  has_one :organization
 
end
