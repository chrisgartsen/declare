class ContactMessagesController < ApplicationController

  def new
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new(contact_message_params)
    if @contact_message.save
      redirect_to contact_message_path(@contact_message)
    else
      render :new
    end
  end

  def show
    @contact_message = ContactMessage.find(params[:id])
  end

  private

    def contact_message_params
      params.require(:contact_message).permit(:email, :message)
    end

end