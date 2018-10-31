class MkbHandbook < ApplicationRecord



  belongs_to :analysis
  has_many :mse_patients

  validates :code, presence:  {message: 'Укажите код по МКБ-10'}
  validates :description, presence:  {message: 'Укажите название диагноза по МКБ-10'}


  def self.parse_mkb_10
    require 'roo-xls'
    table = Roo::Spreadsheet.open("#{Rails.root}/public/vpch_initial/mkb10.xlsx")
    table.each do |record|
      record_parent = MkbHandbook.where(code: record[2])
      if record_parent.present?
        MkbHandbook.create(code: record[0], description: record[1], ancestry: record_parent.first.id)
      else
        MkbHandbook.create(code: record[0], description: record[1])
      end
    end
  end


end

