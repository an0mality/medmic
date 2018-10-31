class Admin::FoodController < Admin::ApplicationController
  load_and_authorize_resource :recipe_type
  before_action :check_admin
  before_action :sets


  def index
    @set = RecipeType.new
    respond_to do |format|
      format.html {render layout: 'admin'}
      format.js
    end
  end

  def create
    @set = RecipeType.create(set_params)
    respond_to do |f|
      if @set.save
        f.js { render layout: false, content_type: 'text/javascript' }
      else
        f.js {render js: "alert('Ошибка при сохранении')"}
      end
    end
  end

  def update
    set = RecipeType.find(params[:id])
    respond_to do |format|
      if set.update_attributes(set_params)
        format.json { respond_with_bip(set) }
      else
        format.json { respond_with_bip(set) }
      end
    end
  end

  def destroy
    @set = RecipeType.find(params[:id])
    respond_to do |format|
      unless @set.use_set
        if @set.destroy
          format.js
        end
      else
        format.js {render js: "alert('Удалить запись невозможно,т.к. она связана с другими.')"}
      end
    end
  end

private

  def set_params
    params.require(:recipe_type).permit!
  end

  def sets
    @sets = RecipeType.order('old, name')
  end
end
