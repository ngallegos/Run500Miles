class AdminController < ApplicationController
  before_action :admin_user, only: [:edit_quote, :update_quote]
  before_action :dev_user,   only: [:site_config, :new_config, :create_config,
                                    :config_index, :update_config, :destroy_config]

  def new_config
    @config = Configuration.new
  end

  def create_config
    @config = Configuration.new(config_params)
    if @config.save
      flash[:success] = "Configuration successfully created!"
      redirect_to config_index_path
    else
      render 'new_config'
    end
  end

  def config_index
    @configs = Configuration.all
  end

  def site_config
    @config = Configuration.find(params[:id])
  end

  def update_config
    @config = Configuration.find(params[:id])
    if @config.update(config_params)
      flash[:success] = "Config Updated"
      redirect_to config_index_path
    else
      render 'site_config'
    end
  end

  def destroy_config
    Configuration.find(params[:id]).destroy
    flash[:success] = "Configuration destroyed"
    redirect_to config_index_path
  end

  def edit_quote
  end

  def update_quote
    if params[:qotw][:quote].present? && params[:qotw][:source].present?
      q_content = Configuration.find_by(key: 'quote-content')
      q_source  = Configuration.find_by(key: 'quote-source')
      q_content.value = params[:qotw][:quote]
      q_source.value  = params[:qotw][:source]
      if q_content.save && q_source.save
        flash[:success] = "Quote Updated."
        redirect_to root_path
      else
        render 'edit_quote'
      end
    else
      flash[:error] = "You must provide both a quote and a source"
      render 'edit_quote'
    end
  end

  private

    def config_params
      params.require(:configuration).permit(:key, :value)
    end

    def dev_user
      redirect_to(root_path) unless current_user&.email == "nicholas.gallegos@gmail.com"
    end

    def admin_user
      redirect_to(root_path) unless current_user&.admin?
    end
end
