class MaterialCommentsController < ApplicationController
  unloadable
  default_search_scope :materials
  model_object Material
  before_action :find_model_object
  before_action :find_project_from_association
  before_action :authorize
  after_action :send_notification, :only => :create

  def create
    raise Unauthorized unless @material.commentable?

    @comment = Comment.new
    @comment.safe_attributes = params[:comment]
    @comment.author = User.current
    if @material.comments << @comment
      flash[:notice] = l(:label_comment_added)
    end

    redirect_to project_material_path(@material.project_id, @material)
  end

  def destroy
    @material.comments.find(params[:comment_id]).destroy
    redirect_to project_material_path(@material.project_id, @material)
  end

  private

  def find_model_object
    super
    @material = @object
    @comment = nil
    @material
  end

  def send_notification
    if Setting.notified_events.include?('material_comment_added')
      MaterialMailer.material_comment_added(@comment).deliver
    end
  end

end
