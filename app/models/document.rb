class Document < ApplicationRecord

  def self.frmr
    Document.where('lower(filename) like lower (?)', "%врачей и фельдшеров%").first
  end

  def self.open
    Document.where('lower(filename) like lower (?)', "%вход%").first
  end

  def self.ticket
    Document.where('lower(filename) like lower (?)', "%заяв%").first
  end

  def self.vpch
    Document.where('lower(filename) like lower (?)', "%впч%").first
  end

  def self.ipra_user
    Document.where('lower(filename) like lower (?)', "%ипра_мо%").first
  end

  def self.ipra_mz
    Document.where('lower(filename) like lower (?)', "%ипра_мз%").first
  end

  def self.feed_user
    Document.where('lower(filename) like lower (?)', "%питание_мо%").first
  end

  def self.feed_mz
    Document.where('lower(filename) like lower (?)', "%питание_мз%").first
  end

  def self.moder
    Document.where('lower(filename) like lower (?)', "%модератор%").first
  end

end
