# frozen_string_literal: true

class BasketsController < ApplicationController
  before_action :set_user, only: %i[add_product show]
  before_action :set_basket, only: %i[update destroy]

  # GET /baskets/1 or /baskets/1.json
  def show
    authorize @user, :show_basket?

    @basketed = @user.basketed.includes(:product)
  end

  def add_product
    authorize Basket, :add_product?

    product = Product.find(add_basket_params[:product_id])

    result = Basket::AddProduct.new(user: current_user).call(
      product: product,
      count: add_basket_params[:count]
    )

    if result
      flash.notice = "#{product.name} added to basket"
    else
      flash.alert = "Cannot add #{product.name} to basket"
    end

    redirect_to :products
  end

  # PATCH/PUT /baskets/1 or /baskets/1.json
  def update
    authorize @basket

    respond_to do |format|
      if @basket.update(basket_params)
        format.html { redirect_to :user_basket, notice: 'Basket was successfully updated.' }
      else
        format.html { redirect_to :user_basket, alert: @basket.errors.full_messages.join(', ') }
      end
    end
  end

  # DELETE /baskets/1 or /baskets/1.json
  def destroy
    authorize @basket

    @basket.destroy
    respond_to do |format|
      format.html { redirect_to :user_basket, notice: 'Product was successfully deleted from basket.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:user_id])
  end

  def set_basket
    @basket = Basket.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def basket_params
    params.require(:basket).permit(:count)
  end

  def add_basket_params
    params.require(:basket).permit(:product_id, :count)
  end
end
