# frozen_string_literal: true

class ContactsController < ApplicationController
  def index
    skip_policy_scope

    @country = params[:country]&.upcase || 'US'
    @address = "Some place in <b>#{ISO3166::Country.new(@country)&.name}</b>"
    @management_message = Management::Message.new(
      name: current_user&.full_name,
      email: current_user&.email
    )
  end
end
