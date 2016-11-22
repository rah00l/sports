class MainController < ApplicationController
	before_action :authenticate_user! ,:except => [:index]
	def index
		@sports = Sport.order("created_at desc").page(params[:page]).per_page(20)
		respond_to do |format|
			format.html
			format.js
		end
	end
end
