class FrmrQuality < FrmrConnection
  FrmrQuality.table_name='frmr_qualities'
  has_many :frmr_doctors
end
