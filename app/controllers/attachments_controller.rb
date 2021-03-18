class AttachmentsController < ApplicationController

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    if current_user.author_of?(@file.record)
      @file.purge
      if @file.record.is_a?(Answer)
        redirect_to @file.record.question
      else
        redirect_to @file.record
      end
    end
  end
end
