class LinksController < ApplicationController

  def destroy
    @link = Link.find(params[:id])
    if current_user.author_of?(@link.linkable)
      @link.destroy
      if @link.linkable.is_a?(Answer)
        redirect_to @link.linkable.question
      else
        redirect_to @link.linkable
      end
    end
  end
end
