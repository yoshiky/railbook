#coding: utf-8

require 'kconv'

class BooksController < ApplicationController
  before_filter :authenticate_user!, :only => ['new','edit','destroy']

  # GET /books
  # GET /books.json
  def index
    #@books = Book.all
    @books = Book.find(:all, :order => "isbn")
    @book_images = []

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
    @review = Review.find_all_by_book_id(@book.id)
    @book_image = BookImage.find_all_by_book_id(@book.id)

    #レビュー投稿用にセッションにbook_idを保持
    session[:book_id] = @book.id

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
    #@book_image = BookImage.find_all_by_book_id(@book.id)
    @book_image = @book.book_images
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(params[:book])
    @book_image = @book.book_images.build()

    #アップロード処理
    self.upload_pics

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end

  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])
    @book_image = BookImage.new(params[:book_image])

    #アップロード処理
    ret = self.upload_pics

    ActiveRecord::Base.transaction do
      @book.update_attributes(params[:book])
      if ret == 1
        @book.book_images << @book_image
      end
      flash[:notice] = '変更を保存しました。'
      redirect_to :action => 'show', :id => @book
    end

#    respond_to do |format|
#      if @book.update_attributes(params[:book])
#        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
#        format.json { head :ok }
#      else
#        format.html { render action: "edit" }
#        format.json { render json: @book.errors, status: :unprocessable_entity }
#      end
#    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :ok }
    end 
  end

  def list
    @books = Book.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  def upload_pics

    #アップロード処理
    if params[:book_image].blank?
      return 0
    else
      file = params[:book_image][:image_name]
      name = file.original_filename
      #新規登録用
      @book_image.image_name = "#{name}"
      #更新用
      params[:book_image][:image_name] = "#{name}"

      perms = ['.jpg','.jpeg','.gif','.png','.bmp']

      if !perms.include?(File.extname(name).downcase)
        result = 'アップロードできるのは画像ファイルのみです。'

      elsif file.size > 1.megabyte
        result = 'ファイルサイズは1MBまでです。'
      else
        name = name.kconv(Kconv::SJIS, Kconv::UTF8)
        File.open("/home/nagatsuka/railbook_contents/#{name}", 'wb'){|f| f.write(file.read)}
        #result = "#{name.toutf8}をアップロードしました。"
      end
      return 1
    end
      
  end

  def image
    if params[:file].blank?
      render :nothing => true, :status => 404
      return
    end

#    path = File.join(SYSTEM_CONFIG[:img_dir],
#      params[:file])
#    send_file path, :disposition => 'inline'
    send_file '/home/nagatsuka/railbook_images/title_image.JPG',:type => 'image/jpeg', :disposition => 'inline'
  end

end