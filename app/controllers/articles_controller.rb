class ArticlesController < ApplicationController
  
  # its a frequent practice to place the standard CRUD actions in each controller
  # in the following order: index, show, new, edit, create, update, and destroy
  
  http_basic_authenticate_with name: "test_user", password: "test_password", except: [:index, :show]
  
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end
  
  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(article_params)
    
    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])
    
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end

  private
    # using private method to encapsulate permissible parameters is a good pattern
    # since you will be able to reuse the same permit list between create and update
    # if dont include permit list, then will get ActiveModel::ForbiddenAttributes exception
    # moves mass-assignment protection out of the model and into the controller
    # because access control to the model is the job of the controller
    def article_params
      params.require(:article).permit(:title, :text)
    end
end
