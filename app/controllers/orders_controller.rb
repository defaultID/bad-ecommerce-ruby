# frozen_string_literal: true

class OrdersController < ApplicationController
  include TokenAuthentication

  before_action :require_login
  before_action :set_user, only: %i[index xml_index create]
  before_action :set_order, only: %i[
    show
    pay confirm_payment
    confirm confirm_shipment confirm_receipt
    destroy
  ]

  prepend_before_action :authenticate_by_token, only: %i[xml_index]
  skip_before_action :verify_authenticity_token, only: %i[xml_index]

  # GET /orders or /orders.xml
  def index
    authorize @user, :show_orders?

    @orders = policy_scope(@user.orders).order(created_at: :desc)
  end

  def xml_index
    authorize @user, :show_orders?

    @orders = policy_scope(@user.orders).order(created_at: :desc)

    parse_request_xml if request.body.size.positive?

    @orders = @orders.includes(items: :product)
  end

  # GET /orders/1
  def show
    authorize @order

    @order_items = @order.items.includes(:product)
  end

  # POST /orders
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

  # DELETE /orders/1
  def destroy
    authorize @order

    @order.destroy!

    redirect_to user_orders_path(@order.user_id), notice: 'Order was successfully destroyed.'
  end

  private

  def parse_request_xml
    xml_body = Nokogiri::XML(request.body) do |config|
      config.strict.noent
    end

    @date_start = xml_body.at_css('orders>dateStart').text
    @date_end = xml_body.at_css('orders>dateEnd').text

    @orders = @orders.where('created_at > ?', @date_start) if @date_start.present?
    @orders = @orders.where('created_at < ?', @date_end) if @date_end.present?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:user_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
