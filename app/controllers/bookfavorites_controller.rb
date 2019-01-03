class BookfavoritesController < ApplicationController
protect_from_forgery with: :exception
	 include SessionsHelper

    before_action :require_login
		before_action :find_book,only: [:new, :create]
    before_action :find_favorite,:find_user,only: [:destroy]
    def new
       @bookfavorite = Bookfavorite.new
    end

	def create
		@bookfavorite = Bookfavorite.where(:book_id => @book.id,:user_id => current_user.id).first
		if @bookfavorite.nil?
			@bookfavorite = Bookfavorite.new
			@bookfavorite.book_id = @book.id
			@bookfavorite.user_id = @current_user.id
			if @bookfavorite.save
				flash[:success] = "Thêm sách yêu thích thành công !"
				redirect_to book_path(@book)
			end
			else
				flash[:danger] = "Bạn đã thêm sách này rồi !"
				redirect_to book_path(@book)
			end
		end

   def show
   end

   def edit
    end

   def destroy
     @bookfavorite1.destroy
		 flash[:success] = "Xóa sách yêu thích thành công !"
     redirect_to user_path(@user)
    end

    private

	def find_book
		 if params[:book_id].present?
			@book = Book.find(params[:book_id])
 		end
	end
	def find_user
     @user = User.find(params[:user_id])
	end
   	def find_favorite
      @bookfavorite1 = Bookfavorite.find(params[:id])
    end
    end
