class Api::V1::UsersController < Api::V1::ApiController
  def index
    @users = User.all

    return render_not_found if @users.nil?
    return render status: :ok, json: { message: 'Ainda não há Users cadastrados' }.as_json if @users.empty?

    render status: :ok, json: UserSerializer.new(@users).serializable_hash
  end

  def show
    @user = User.find(params[:id])

    render status: :ok, json: @user
  end

  def managers
    @users = User.user

    render status: :ok, json: @users, each_serializer: ManagerSerializer
  end

  def professionals
    @users = User.joins(:professional_profile).professional

    # render status: :ok, json: @users
    render status: :ok, json: @users, each_serializer: UserAmsSerializer
    # render status: :ok, json: @users, each_serializer: AnotherUserSerializer
  end
end
