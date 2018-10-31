class Analysis < VpchConnection
  Analysis.table_name = "analyses"

  scope :in_registry, -> {where('registry_id IS NOT NULL and error_add is false')}
  scope :not_registry, -> {where(registry_id: nil, error_add: false).order(:reception_at)}
  scope :no_error, -> {where('error_add = false')}

  belongs_to :registry
  belongs_to :organization
  belongs_to :user
  has_many :mkb_handbooks

  validates_presence_of :mkb_handbook_id, :scraping
  validates :last_menstruation_date, presence: {if: -> { menopause.blank?}}
  validates :menopause, presence: {if: -> { last_menstruation_date.blank?}}

  SCRAPING_TYPE = {0 => {name: 'Не указано'},1 => {name: 'Влагалище'}, 2 => {name: 'Экзоцервикс'}, 3 => {name: 'Эндоцервикс'}}
  NEXT_VISIT = {0 => {name: 'не указано'}, 1 => {name: 'через 6 месяцев'}, 2 => {name: 'через 1 год'}, 3 => {name: 'через 3 года'}, 4 => {name: 'Указать на календаре'}}

  def self.create_analysis params, current_user
    mkb = MkbHandbook.where(code: params[:mkb_handbook_code])
    mkb_id = mkb.present? ? mkb.first.id : :null
    @analysis = Analysis.create(group_age: params.require(:analysis)[:group_age],
                                user_id: current_user.id,
                                patient_id: params.require(:analysis)[:patient_id],
                                reception_at: Time.now,
                                visual: params.require(:analysis)[:visual],
                                organization_id: current_user.organization_id,
                                analys_key: params.require(:analysis)[:analys_key],
                                mkb_handbook_id: mkb_id,
                                last_menstruation_date: params.require(:analysis)[:last_menstruation_date],
                                menopause: params.require(:analysis)[:menopause],
                                therapy: params.require(:analysis)[:therapy],
                                scraping: params.require(:analysis)[:scraping])
  end

  def self.next_visit next_visit, reception_at
    case next_visit.to_i
      when 0
        t = reception_at + 1.year
      when 1
        t = reception_at + 6.months
      when 2
        t = reception_at + 1.year
      when 3
        t = reception_at + 3.year
      when 4
        t = nil
    end
    t
  end

  def scraping_name
    case self.scraping
      when 0 then return 'Не указано'
      when 1 then return 'Влагалище'
      when 2 then return 'Экзоцервикс'
      when 3 then return 'Эндоцервикс'
    end
  end


end
