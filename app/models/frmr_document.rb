class FrmrDocument < FrmrConnection
  FrmrDocument.table_name='frmr_documents'


  belongs_to :user
  belongs_to :organization
  belongs_to :frmr_document_type

  scope :not_processed, ->{where(frmr_document_type_id: 1)}
  scope :adopted, ->{where(frmr_document_type_id: 2)}
  scope :rejected, ->{where(frmr_document_type_id: 3)}
  default_scope {order(id: :desc)}
end
