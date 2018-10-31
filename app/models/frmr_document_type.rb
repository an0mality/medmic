class FrmrDocumentType < FrmrConnection
  FrmrDocumentType.table_name='frmr_document_types'
  has_many :frmr_documents
end
