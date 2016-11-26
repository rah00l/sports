class SportsController < ApplicationController
  before_action :set_sport, only: [:show, :edit, :update, :destroy]
  before_action :alphabetical_sports_list, only: :index
  # layout 'sport_page', :only => [:show]
  # GET /sports
  # GET /sports.json
  def index
     @letter = params[:letter] ? ((params[:letter] == 'all') ? '' : params[:letter]) : ''
    if params[:letter] && !params[:letter].eql?('All')
      @sports = Sport.by_letter(params[:letter]).page(params[:page]).per_page(10)
    else
      @sports = Sport.page(params[:page]).per_page(20)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /sports/1
  # GET /sports/1.json
  def show
    @prev = @sport.previous
    @next = @sport.next
  end

  # GET /sports/new
  def new
    @sport = Sport.new
  end

  # GET /sports/1/edit
  def edit
  end

  # POST /sports
  # POST /sports.json
  def create
    @sport = Sport.new(sport_params)

    respond_to do |format|
      if @sport.save
        format.html { redirect_to @sport, notice: 'Sport was successfully created.' }
        format.json { render :show, status: :created, location: @sport }
      else
        format.html { render :new }
        format.json { render json: @sport.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sports/1
  # PATCH/PUT /sports/1.json
  def update
    respond_to do |format|
      if @sport.update(sport_params)
        format.html { redirect_to @sport, notice: 'Sport was successfully updated.' }
        format.json { render :show, status: :ok, location: @sport }
      else
        format.html { render :edit }
        format.json { render json: @sport.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sports/1
  # DELETE /sports/1.json
  def destroy
    @sport.destroy
    respond_to do |format|
      format.html { redirect_to sports_url, notice: 'Sport was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sport
      @sport = Sport.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sport_params
      params.fetch(:sport, {})
    end

    def alphabetical_sports_list
      all_sports = Sport.pluck(:name)
      @first_letters = []
      all_sports.each {|word| @first_letters << word[0,1]}
    end
end
