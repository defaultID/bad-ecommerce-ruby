# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_user, only: %i[index create]
  before_action :set_order, only: %i[
    show
    pay confirm_payment
    confirm confirm_shipment confirm_receipt
    destroy
  ]

  # GET /orders or /orders.json
  def index
    @orders = policy_scope(@user.orders).order(created_at: :desc)
  end

  # GET /orders/1 or /orders/1.json
  def show
    authorize @order

    @order_items = @order.items.includes(:product)
  end

  # POST /orders or /orders.json
  def create
    authorize @user, :order?

    @order = Order::CreateOrder.instance.call(user: current_user)

    if @order
      redirect_to @order, notice: 'Order was successfully created.'
    else
      redirect_to user_basket_path(@user), alert: 'Cannot create order.'
    end
  end

  def pay
    authorize @order

    @order.pending_status!

    unless session[:address_confirmed] # rubocop:disable Style/GuardClause
      session[:return_to_order] = @order.id
      redirect_to edit_user_path(@order.user), notice: 'Please confirm user name and address:' and return
    end
  end

  def confirm_payment
    authorize @order

    if Order::ConfirmPayment.instance.call(
      order: @order,
      method: params[:payment_method],
      key: params[:confirmation_key]
    )
      redirect_to confirm_order_path(@order)
    else
      redirect_to @order, alert: 'Payment confirmation failed'
    end
  end

  def confirm
    authorize @order

    if Order::ConfirmOrder.instance.call(order: @order)
      redirect_to @order, notice: 'Order confirmed'
    else
      redirect_to @order, alert: 'Cannot confirm this order'
    end
  end

  def confirm_shipment
    authorize @order

    if Order::ConfirmShipment.instance.call(order: @order)
      redirect_to @order, notice: 'Order successfully marked as shipped'
    else
      redirect_to @order, alert: 'Cannot update order status'
    end
  end

  def confirm_receipt
    authorize @order

    if Order::ConfirmReceipt.instance.call(order: @order)
      redirect_to @order, notice: 'Order successfully marked as received'
    else
      redirect_to @order, alert: 'Cannot update order status'
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    authorize @order

    @order.destroy!

    redirect_to user_orders_path(@order.user_id), notice: 'Order was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:user_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
