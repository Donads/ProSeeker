class Api::V1::ProfessionalProfilesController < Api::V1::ApiController
  def index
    @professional_profiles = ProfessionalProfile.all

    return render_not_found if @professional_profiles.nil?

    render status: :ok, json: @professional_profiles
  end

  def show
    @professional_profile = ProfessionalProfile.find(params[:id])

    render status: :ok, json: @professional_profile
  end
end
