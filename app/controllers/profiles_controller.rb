class ProfilesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_profile, only: %i[ show update destroy ]

  # GET /profiles
  def index
    @profiles = current_user.profiles

    render json: @profiles
  end

  # GET /profiles/1
  def show
    render json: @profile
  end

  # POST /profiles
  def create
    userProfiles = current_user.profiles

    if userProfiles.length() < 4
      @profile = current_user.profiles.new(profile_params)

      if @profile.save
        render json: @profile, status: :created, location: @profile
      else
        render json: @profile.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Máximo de 4 perfis por usuário" }
    end
  end

  # PATCH/PUT /profiles/1
  def update
    if @profile.update(profile_params)
      render json: @profile
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/1
  def destroy
    @profile.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = current_user.profiles.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:name, :user_id)
    end
end
