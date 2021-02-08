class Api::UsersController < ApplicationController
  before_action :find_user, only: [:update, :destroy, :show]

  def index
    users = User.all.page(params[:page])
    render json: users, each_serializer: UserSerializer
  end

  def show
    render json: @user, serializer: UserSerializer
  end

  def destroy
    @user.destroy
    render json: {message: "User successfully destroyed"}, adapter: :json
  end

  def update
    if @user.update(user_params)
      render json: @user, serializer: UserSerializer
    else
      render json: {errors: @user.errors}, adapter: :json
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, serializer: UserSerializer
    else
      render json: {errors: user.errors}, adapter: :json
    end
  end

  def typeahead
    search = "%#{params[:input].parameterize}%"
    users = User.search(search, fields: [:first_name, :last_name, :email], match: :word_middle, operator: 'or')
    render json: users ,each_serializer: UserSerializer
  end

  private

    def find_user
      @user = User.find(params[:id])
      unless @user.present?
        render json: {message: "user not found"}
      end
    end

    def user_params
      params.require(:user).permit(:first_name,:last_name,:email)
    end
end
