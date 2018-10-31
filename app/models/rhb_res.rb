class RhbRes < MseConnection
  RhbRes.table_name = "rhb_res"
  has_one :prg_rhb
end
