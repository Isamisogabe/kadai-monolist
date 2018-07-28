class ItemsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_item?, only: [:show]
  
  def new
    @items = []
    
    @keyword = params[:keyword]
    if @keyword.present?
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })
      
      
      results.each do |result|
        item = Item.find_or_initialize_by(read(result))
        @items << item
      end
    end
  end
  
  def show
    @item = Item.find(params[:id])
    @want_users = @item.want_users
    @have_users = @item.have_users
  end
  
  private 
  
  def correct_item?
    @item = Item.find_by(id: params[:id])
    
    unless @item
      redirect_to root_path
    end
  end
  
  
end
