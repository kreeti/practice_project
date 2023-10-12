class UsersController < ApplicationController
  before_action :authenticate_admin_user, only: [:index, :create, :new, :update, :edit, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: "User created successfully"
    else
      render "new"
    end
  end

  def edit
    user
  end

  def update
    if user.update(user_params)
      redirect_to users_path, notice: "User is updated"
    else
      render "edit"
    end
  end

  def destroy
    user.deactivate!
    redirect_to users_path, notice: "User deleted successfully"
  end

  private

  def user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :admin)
  end
end
