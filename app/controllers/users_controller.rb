# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_login, except: %i[show]
  before_action :set_user, only: %i[show edit update destroy show_picture]

  # GET /users or /users.json
  def index
    authorize User
    @users = policy_scope User
  end

  # GET /users/1 or /users/1.json
  def show
    authorize @user
  end

  # GET /users/new
  def new
    authorize User

    @user = User.new
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # POST /users or /users.json
  def create
    authorize User

    @user = User::CreateUser.instance.call(params: params.require(:user))

    respond_to do |format|
      if @user.persisted?
        format.html { redirect_to @user, flash: { success: 'User was successfully created.' } }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    authorize @user

    @user = User::UpdateUser.new(
      target: @user,
      actor: nil # current_user
    ).call(params: params.require(:user))

    if @user.errors.empty?
      if session[:return_to_order].present?
        session[:address_confirmed] = true

        redirect_to pay_order_path(session[:return_to_order]), notice: 'User address was successfully confirmed.'

        session.delete(:return_to_order)
      else
        redirect_to @user, flash: { success: 'User was successfully updated.' }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    authorize @user

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, flash: { success: 'User was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  def show_picture
    authorize @user

    file_name = File.basename params[:name]
    file_path = Rails.root.join "public/uploads/users/#{@user.id}/#{file_name}"

    unless File.exist?(file_path)
      redirect_to(
        helpers.asset_pack_path('media/images/No_image_available.svg')
      ) and return
    end

    file_type = MimeMagic.by_magic(File.open(file_path)) || 'application/octet-stream'

    send_file file_path, type: file_type, disposition: 'inline'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
