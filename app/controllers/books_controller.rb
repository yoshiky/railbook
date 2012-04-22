#coding: utf-8

require 'kconv'

class BooksController < ApplicationController
  before_filter :authenticate_user!, :only => ['new','edit','destroy']

  # GET /books
  # GET /books.json
  def index
    #@books = Book.all
    @books = Book.find(:all, :order => "isbn")

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
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(params[:book])

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

    #アップロード処理
    self.upload_pics

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
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
    if params[:book][:img_url]
      #file = @book.img_url
      file = params[:book][:img_url]
      name = file.original_filename
      #新規登録用
      @book.img_url = "#{name}"
      #更新用
      params[:book][:img_url] = "#{name}"

      perms = ['.jpg','.jpeg','.gif','.png','.bmp']
      if !perms.include?(File.extname(name).downcase)
        result = 'アップロードできるのは画像ファイルのみです。'

      elsif file.size > 1.megabyte
        result = 'ファイルサイズは1MBまでです。'
      else
        name = name.kconv(Kconv::SJIS, Kconv::UTF8)
        File.open("app/assets/images/#{name}", 'wb'){|f| f.write(file.read)}
        #result = "#{name.toutf8}をアップロードしました。"
      end
    end
  end
end
