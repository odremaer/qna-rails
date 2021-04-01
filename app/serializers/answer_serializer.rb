class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :user_id, :created_at, :updated_at, :files

  has_many :comments
  has_many :links

  def files
    @files_url = []
    object.files.each do |file|
      @files_url << rails_blob_url(file, only_path: true)
    end
    @files_url
  end
end
