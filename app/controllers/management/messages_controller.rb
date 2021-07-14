# frozen_string_literal: true

module Management
  class MessagesController < ApplicationController
    before_action :set_management_message, only: %i[destroy]
    before_action :require_login, except: %i[create]

    # GET /management/messages or /management/messages.json
    def index
      authorize Management::Message

      @management_messages = policy_scope(Management::Message.all).order(created_at: :desc)
    end

    # POST /management/messages or /management/messages.json
    def create
      authorize Management::Message

      @management_message = Management::Message.new(management_message_params)
      @management_message.user = current_user if logged_in?

      if @management_message.save
        redirect_back fallback_location: root_path, notice: 'Message was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # DELETE /management/messages/1 or /management/messages/1.json
    def destroy
      authorize @management_message

      @management_message.destroy

      redirect_to management_messages_url, notice: 'Message was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_management_message
      @management_message = Management::Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def management_message_params
      params.require(:management_message).permit(:name, :email, :message)
    end
  end
end
